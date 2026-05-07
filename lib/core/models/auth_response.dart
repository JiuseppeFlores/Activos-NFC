import 'package:activos_nfc_app/common/data/data.dart';

class AuthResponse {
  final String token;
  final SessionUser user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? DefaultData.string,
      user: SessionUser.fromJson(json['usuario'] ?? {}),
    );
  }
}

class SessionUser {
  final int id;
  final String name;
  final int roleId;
  final int areaId;

  SessionUser({
    required this.id,
    required this.name,
    required this.roleId,
    required this.areaId,
  });

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: json['idUsuario'] ?? DefaultData.int,
      name: json['nombre'] ?? DefaultData.string,
      roleId: json['idRol'] ?? DefaultData.int,
      areaId: json['idArea'] ?? DefaultData.int,
    );
  }
}
