import 'package:activos_empresa_app/common/data/data.dart';

class Session {
  final int _id;
  final String _username;
  final String _password;
  final String _token;
  Session({
    int id = DefaultData.int,
    String username = DefaultData.string,
    String password = DefaultData.string,
    String token = DefaultData.string,
})  :   _id = id,
        _username = username,
        _password = password,
        _token = token;

  Session copyWith({
    int? id,
    String? username,
    String? password,
    String? token,
  }) => Session(
    id: id ?? _id,
    username: username ?? _username,
    password: password ?? _password,
    token: token ?? _token,
  );

  int get id => _id;
  String get username => _username;
  String get password => _password;
  String get token => _token;

  bool get isStarted => _id != 0 && _username.isNotEmpty && _password.isNotEmpty;
  bool get withCredentials => _username.isNotEmpty && _password.isNotEmpty;

  @override
  String toString() 
    => 'Session{'
          'id=$_id, '
          'username=$_username, '
          'password=$_password, '
          'token=$_token '
        '}';

}
