import 'package:base_app/core/helpers/dynamic_parse.dart';
import 'package:base_app/core/helpers/error_manager.dart';
import 'package:base_app/data/datasources/models/login_model.dart';
import 'package:base_app/data/dio/custom_dio_error.dart';
import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/data/dio/my_dio.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/domain/entities/login_entity.dart';
import 'package:base_app/domain/repositories/remote/dtos/change_password_dto.dart';
import 'package:base_app/domain/repositories/remote/dtos/login_dto.dart';
import 'package:base_app/domain/repositories/remote/dtos/register_user_dto.dart';
import 'package:base_app/domain/repositories/remote/usecases/auth_remote_repository.dart';

class AuthEndpoints extends AuthRemoteRepository {
  final MyDio _myDio;
  AuthEndpoints(this._myDio);

  final String localPathV1 = "v1/auth";

  @override
  Future<CustomResponse<LoginEntity>> login(LoginDto dto) async {
    try {
      final res = await _myDio.post(
        path: "$localPathV1/login",
        data: dto.toMap(),
      );
      final loginEntity = DynamicParse.toObjectOrNull(
        res,
        (item) => LoginModel.fromMap(item).toEntity(),
      );
      if (loginEntity == null) {
        return CustomResponse.error(
          type: ErrorType.userOrPasswordIncorrect,
          message: 'El usuario o la contraseña son incorrectos',
        );
      }

      final token = loginEntity.accessToken;
      _myDio.updateToken(token);
      await MyShared.setValue(MySharedConstants.accessToken, token);
      await MyShared.setValue(MySharedConstants.userId, loginEntity.user.id);
      return CustomResponse.ok(type: res['type'], data: loginEntity);
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
  Future<CustomResponse> register(RegisterUserDto dto) async {
    try {
      final res = await _myDio.post(
        path: "$localPathV1/register",
        data: dto.toMap(),
      );
      return CustomResponse.ok(data: res);
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
  Future<CustomResponse> resendVerificationCode({required String email}) async {
    try {
      await _myDio.get(path: "$localPathV1/resend-verification-code/$email");
      return CustomResponse.ok();
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
  Future<CustomResponse> changePassword(ChangePasswordDto dto) async {
    try {
      await _myDio.post(
        path: "$localPathV1/change-password",
        data: dto.toMap(),
      );
      return CustomResponse.ok();
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
  Future<CustomResponse> sendCode({required String email}) async {
    try {
      await _myDio.get(path: "$localPathV1/forgot-password/$email");
      return CustomResponse.ok();
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
  Future<CustomResponse> verifyForgotPassword({
    required String email,
    required String activationCode,
    required String password,
  }) async {
    try {
      await _myDio.post(
        path: "$localPathV1/verify-forgot-password",
        data: {
          "email": email,
          "activationCode": activationCode,
          "password": password,
        },
      );
      return CustomResponse.ok();
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
  Future<CustomResponse> logout() async {
    try {
      final res = await _myDio.get(path: "$localPathV1/logout");
      return CustomResponse.ok(type: res is Map ? res['type'] : null);
    } on CustomDioError catch (e) {
      return CustomResponse.fromCustomDioError(e);
    } catch (e) {
      return CustomResponse.error(
        type: ErrorType.unknownError,
        message: e.toString(),
      );
    } finally {
      _myDio.updateToken(null);
      await MyShared.removeKey(MySharedConstants.accessToken);
      await MyShared.removeKey(MySharedConstants.userId);
      await MyShared.removeKey(MySharedConstants.userData);
    }
  }

  @override
  void setToken(String token) {
    _myDio.updateToken(token);
  }
}
