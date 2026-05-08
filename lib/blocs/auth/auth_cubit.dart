import 'package:activos_nfc_app/blocs/auth/auth_state.dart';
import 'package:activos_nfc_app/core/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final session = await _authRepository.getSavedSession();
    
    if (session.username.isNotEmpty && session.password.isNotEmpty) {
      await login(session.username, session.password);
    } else {
      emit(state.copyWith(status: AuthStatus.loggedOut));
    }
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final response = await _authRepository.login(username, password);
    
    if (response.isSuccessful) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        authResponse: response.data,
        username: username,
        password: password,
      ));
    } else {
      await _authRepository.clearSession();
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: response.error.replaceAll('<br>', '\n'),
      ));
    }
  }

  Future<void> logout() async {
    await _authRepository.clearSession();
    emit(state.copyWith(status: AuthStatus.loggedOut));
  }
}
