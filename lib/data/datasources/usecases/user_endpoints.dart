import 'package:base_app/data/dio/custom_dio_error.dart';
import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/data/datasources/models/user_model.dart';
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:base_app/domain/repositories/remote/usecases/user_remote_repository.dart';

import '../../dio/my_dio.dart';

class UserEndpoints extends UserRemoteRepository {
  final MyDio _myDio;
  UserEndpoints(this._myDio);

  final String localPath = "user";

  @override
  Future<CustomResponse<UserEntity>> getMyInfo() async {
    try {
      final (res, data) = await _myDio.get(path: "$localPath/me");
      if (data == null) return CustomResponse(statusCode: 400);
      return CustomResponse(
        statusCode: res.statusCode ?? 200,
        data: UserModel.fromMap(data).toEntity(),
      );
    } on CustomDioError catch (e) {
      return CustomResponse(
        statusCode: e.code,
        message: e.message,
        type: e.type,
      );
    } catch (e) {
      return CustomResponse(statusCode: 400, message: e.toString());
    }
  }
}
