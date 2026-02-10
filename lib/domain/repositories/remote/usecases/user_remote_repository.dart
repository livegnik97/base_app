import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/domain/entities/user_entity.dart';

abstract class UserRemoteRepository {
  Future<CustomResponse<UserEntity>> getMyInfo();
}
