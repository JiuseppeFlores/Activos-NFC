import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static Future<String?> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }

  static Future<void> setToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', token);
  }

  static Future<void> saveSession(Session session) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', session.id);
    await sharedPreferences.setString('username', session.username);
    await sharedPreferences.setString('password', session.password);
    await sharedPreferences.setString('token', session.token);
  }

  static Future<Session> getSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Session(
      id: sharedPreferences.getInt('id') ?? DefaultData.int,
      username: sharedPreferences.getString('username') ?? DefaultData.string,
      password: sharedPreferences.getString('password') ?? DefaultData.string,
      token: sharedPreferences.getString('token') ?? DefaultData.string,
    );
  }
}
