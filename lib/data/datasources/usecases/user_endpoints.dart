import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/core/helpers/error_manager.dart';
import 'package:base_app/data/datasources/models/user_model.dart';
import 'package:base_app/data/dio/custom_dio_error.dart';
import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:base_app/domain/repositories/remote/usecases/user_remote_repository.dart';

import '../../dio/my_dio.dart';

class UserEndpoints extends UserRemoteRepository {
  final MyDio _myDio;
  UserEndpoints(this._myDio);

  final String localPathV1 = "v1/users";

  @override
  Future<CustomResponse<UserEntity>> getMyData() async {
    try {
      final res = await _myDio.get(path: "$localPathV1/my-data");
      final user = DynamicParse.toObjectOrNull(
        res,
        (item) => UserModel.fromMap(item),
      );
      if (user != null) {
        await MyShared.setValue(MySharedConstants.userId, user.id);
      }
      return CustomResponse.ok(data: user?.toEntity());
    } on CustomDioError catch (e) {
      return CustomResponse.fromCustomDioError(e);
    } catch (e) {
      return CustomResponse.error(
        type: ErrorType.unknownError,
        message: e.toString(),
      );
    }
  }

  @override
  void changeLanguage(String language) {
    _myDio.updateLanguage(language);
  }
}
