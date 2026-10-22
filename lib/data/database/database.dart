import 'package:base_app/data/sqlite_handler/sqlite_handler.dart';

/// Singleton de acceso a la base de datos local de la app.
///
/// Para usar SQLite en un módulo:
/// - exponer el repositorio/local usecase aquí como getter, y
/// - inicializarlo en el constructor con [sqliteHandler].
class AppDatabase {
  AppDatabase._();

  static final AppDatabase _instance = AppDatabase._();

  static AppDatabase getInstance() => _instance;

  final SqliteHandler sqliteHandler = SqliteHandler();
}
