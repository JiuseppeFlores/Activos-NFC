import 'package:activos_nfc_app/blocs/auth/auth_state.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/core/repositories/auth_repository.dart';
import 'package:activos_nfc_app/core/repositories/session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  AuthCubit({
    AuthRepository? authRepository,
    SessionRepository? sessionRepository,
  })  : _authRepository = authRepository ?? AuthRepository(AuthClient()),
        _sessionRepository = sessionRepository ?? SessionRepository(),
        super(const AuthState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final response = await _authRepository.login(username, password);
    
    if (response.isSuccessful) {
      final AuthResponse authResponse = response.data;
      
      // Persistencia mediante el repositorio de sesión
      final session = Session(
        id: authResponse.user.id,
        username: username,
        password: password,
        token: authResponse.token,
      );
      await _sessionRepository.saveSession(session);
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        authResponse: authResponse,
        username: username,
        password: password,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: response.error.replaceAll('<br>', '\n'),
      ));
    }
  }

  Future<void> logout() async {
    await _sessionRepository.clearSession();
    emit(state.copyWith(status: AuthStatus.loggedOut));
  }
}
