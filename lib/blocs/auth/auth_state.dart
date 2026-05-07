import 'package:activos_nfc_app/core/models/models.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, error, loggedOut }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthResponse? authResponse;
  final String? username;
  final String? password;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authResponse,
    this.username,
    this.password,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? authResponse,
    String? username,
    String? password,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      authResponse: authResponse ?? this.authResponse,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authResponse, username, password, errorMessage];
}
