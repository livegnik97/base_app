import 'dart:async';

import 'package:base_app/core/constants/db_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Handler genérico de SQLite.
///
/// Para usarlo en un módulo:
/// 1. Crear `part 'tables/tu_tabla.dart';` con el SQL de CREATE TABLE/INDEX.
/// 2. Registrar las tablas en [_tablesToCreate] (onCreate) y en
///    [_applyMigrations] (onUpgrade).
/// 3. Bump de [DBConstants.dbVersion] por cada migración nueva.
class SqliteHandler {
  Future<Database>? _database;

  Future<Database> getDb() => _database ??= _open();

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DBConstants.dbName);

    return openDatabase(
      path,
      version: DBConstants.dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final sql in _tablesToCreate) {
      batch.execute(sql);
    }
    for (final sql in _indexesToCreate) {
      batch.execute(sql);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _applyMigrations(db, oldVersion, newVersion);
  }

  //* ---------------------------------------------------------------------------
  //* REGISTRO DE TABLAS Y MIGRACIONES
  //* ---------------------------------------------------------------------------

  /// SQL de CREATE TABLE para las tablas nuevas de la app.
  List<String> get _tablesToCreate => const [];

  /// SQL de CREATE INDEX para las tablas nuevas de la app.
  List<String> get _indexesToCreate => const [];

  /// Migraciones por versión. Ejemplo:
  /// ```dart
  /// if (oldVersion < 2) {
  ///   await db.execute('ALTER TABLE note ADD COLUMN color TEXT');
  /// }
  /// ```
  Future<void> _applyMigrations(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {}

  //* ---------------------------------------------------------------------------
  //* HELPERS CRUD genéricos
  //* ---------------------------------------------------------------------------

  Future<List<Map<String, Object?>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    bool? distinct,
  }) async {
    final db = await getDb();
    return db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      distinct: distinct,
    );
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await getDb();
    return db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await getDb();
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await getDb();
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> rawExecute(String sql, [List<Object?>? arguments]) async {
    final db = await getDb();
    await db.execute(sql, arguments);
  }

  Future<void> rawQuery(String sql, [List<Object?>? arguments]) async {
    final db = await getDb();
    await db.rawQuery(sql, arguments);
  }

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await getDb();
    return db.transaction(action);
  }

  /// Vacía todas las tablas de la BD local (sin borrar el archivo).
  Future<void> clearAll() async {
    final db = await getDb();
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    for (final t in tables) {
      final name = t['name'] as String?;
      if (name == null) continue;
      await db.delete(name);
    }
  }

  /// Cierra y olvida la instancia (para tests o cambio de usuario).
  Future<void> close() async {
    final db = _database;
    _database = null;
    if (db != null) {
      await (await db).close();
    }
  }
}
