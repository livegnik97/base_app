import 'package:base_app/core/firebase/firebase_manager.dart';
import 'package:base_app/data/dio/custom_dio_error.dart';
import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/data/dio/my_dio.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/domain/repositories/remote/usecases/auth_remote_repository.dart';

class AuthEndpoints extends AuthRemoteRepository {
  final MyDio _myDio;
  AuthEndpoints(this._myDio);

  final String localPath = "auth";

  @override
  Future<CustomResponse<String>> login({
    required String email,
    required String password,
    required String firebaseToken,
  }) async {
    try {
      final res = await _myDio.post(
        path: "$localPath/login",
        data: {
          "email": email,
          "password": password,
          "origin": "delivery",
          "firebaseToken": firebaseToken,
        },
      );
      final token = res!['token'];
      _myDio.updateToken(token);
      await MyShared.setValue(MySharedConstants.accessToken, token);
      return CustomResponse(statusCode: 200, type: res.type, data: token);
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

  @override
  Future<CustomResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _myDio.post(
        path: "$localPath/change-password",
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
      return CustomResponse(statusCode: 200);
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

  @override
  Future<CustomResponse> sendCode({required String email}) async {
    try {
      await _myDio.post(
        path: "$localPath/forgot-password",
        data: {"email": email},
      );
      return CustomResponse(statusCode: 200);
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

  @override
  Future<CustomResponse> verifyForgotPassword({
    required String email,
    required String activationCode,
    required String password,
  }) async {
    try {
      await _myDio.post(
        path: "$localPath/verify-forgot-password",
        data: {
          "email": email,
          "activationCode": activationCode,
          "password": password,
        },
      );
      return CustomResponse(statusCode: 200);
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

  @override
  Future<void> logout() async {
    FirebaseManager.remoteSubscription = null;
    _myDio.updateToken(null);
    await MyShared.removeKey(MySharedConstants.accessToken);
    await MyShared.removeKey(MySharedConstants.userData);
  }

  @override
  void setToken(String token) {
    _myDio.updateToken(token);
  }
}
