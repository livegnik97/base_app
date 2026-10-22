import 'package:base_app/data/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.getInstance();
});
