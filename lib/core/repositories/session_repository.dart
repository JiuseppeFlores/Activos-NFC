import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepository {
  Future<void> saveSession(Session session) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', session.id);
    await sharedPreferences.setString('username', session.username);
    await sharedPreferences.setString('password', session.password);
    await sharedPreferences.setString('token', session.token);
  }

  Future<Session> getSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    
    final id = sharedPreferences.getInt('id') ?? DefaultData.int;
    final username = sharedPreferences.getString('username') ?? DefaultData.string;
    final password = sharedPreferences.getString('password') ?? DefaultData.string;
    final token = sharedPreferences.getString('token') ?? DefaultData.string;

    return Session(
      id: id,
      username: username,
      password: password,
      token: token,
    );
  }

  Future<void> clearSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('id');
    await sharedPreferences.remove('username');
    await sharedPreferences.remove('password');
    await sharedPreferences.remove('token');
  }

  Future<String?> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }
}
