import 'package:activos_empresa_app/common/utils/utils.dart';

class FieldData {
  static final username = FieldController(required: true, specialCharacter: false, min: 4, max: 24);
  static final password = FieldController(required: true, min: 3, max: 24);
  static final observation = FieldController(min: 0, max: 255);
}