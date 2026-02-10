import 'package:base_app/data/datasources/api.dart';
import 'package:base_app/domain/repositories/remote/remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<RemoteRepository>((ref) {
  return ApiConsumer.getInstance();
});
