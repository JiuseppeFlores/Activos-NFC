import 'package:activos_nfc_app/common/data/default_data.dart';

class User{

  final int _id;
  final String _name;
  final String _lastname;
  final String _motherLastname;
  final String _identityCard;
  final int _assignmentId;

  User({
    int id = DefaultData.int,
    String name = DefaultData.string,
    String lastname = DefaultData.string,
    String motherLastname = DefaultData.string,
    String identityCard = DefaultData.string,
    int assignmentId = DefaultData.int,
  }) : _id = id, _name = name, _lastname = lastname, 
        _motherLastname = motherLastname, _identityCard = identityCard, 
        _assignmentId = assignmentId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? DefaultData.int,
      name: json['nombre'] ?? DefaultData.string,
      lastname: json['apellidoPaterno'] ?? DefaultData.string,
      motherLastname: json['apellidoMaterno'] ?? DefaultData.string,
      identityCard: json['ci'] ?? DefaultData.string,
      assignmentId: json['idAsignacion'] ?? DefaultData.int,
    );
  }

  int get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get motherLastname => _motherLastname;
  String get identityCard => _identityCard;
  int get assignmentId => _assignmentId;

  String get fullName => '$_name $_lastname $_motherLastname';

  @override
  String toString() 
    => 'User{ '
          'id=$_id, '
          'name=$_name, '
          'lastname=$_lastname, '
          'motherLastname=$_motherLastname, '
          'identityCard=$_identityCard, '
          'assignmentId=$_assignmentId '
        '}';

}