import 'package:activos_empresa_app/common/data/data.dart';

class FieldController {
  final int max;
  final int min;
  final bool specialCharacter;
  final bool strong;
  final bool isEmail;
  final bool required;
  FieldController({
    required this.min,
    required this.max,
    this.specialCharacter = DefaultData.bool,
    this.strong = DefaultData.bool,
    this.isEmail = DefaultData.bool,
    this.required = DefaultData.bool,
  });

  String? validate(String value) {
    if(required){
      if(value.isEmpty){
        return 'El campo es requerido';
      }
    }
    if(min == max){
      if(value.length != min){
        return 'El campo debe contener $min caracteres';
      }
    }
    if (min > DefaultData.int) {
      if (value.length < min) {
        return 'El campo debe contener al menos $min caracteres';
      }
    }
    if (value.length > max) {
      return 'El campo debe contener a lo mas $max caracteres';
    }
    if (specialCharacter) {
      if (_containsSpecialCharacters(value)) {
        return 'Este campo no permite caracteres especiales';
      }
    }

    return null;
  }

  bool _containsSpecialCharacters(String value) {
    RegExp specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(value);
  }
  
}
