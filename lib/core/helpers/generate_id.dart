import 'package:uuid/uuid.dart';

/// Prefijos para generar ids únicos por tipo de entidad.
/// Agregar un valor por cada tipo de entidad de tu proyecto.
enum GenerateIdPrefix {
  user('us'),
  image('im'),
  session('se'),
  record('re'),
  ;

  const GenerateIdPrefix(this.value);
  final String value;
}

/// Generador de ids con prefijo, formato: `xx-uuidv4` o `xx-nombre`.
class GenerateId {
  static const Uuid _uuid = Uuid();

  static String _generateId(GenerateIdPrefix prefix) =>
      '${prefix.value}-${_uuid.v4()}';

  static String _generateIdWithName(GenerateIdPrefix prefix, String name) {
    final nameOk = name.trim().replaceAll(' ', '').toLowerCase();
    return '${prefix.value}-$nameOk';
  }

  static String forUser() => _generateId(GenerateIdPrefix.user);

  static String forImage() => _generateId(GenerateIdPrefix.image);

  static String forSession() => _generateId(GenerateIdPrefix.session);

  static String forRecord() => _generateId(GenerateIdPrefix.record);

  static String forRecordFrom(String name) =>
      _generateIdWithName(GenerateIdPrefix.record, name);
}
