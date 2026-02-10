import 'package:base_app/data/dio/custom_response.dart';

abstract class AuthRemoteRepository {
  Future<CustomResponse<String>> login({
    required String email,
    required String password,
    required String firebaseToken,
  });

  Future<CustomResponse> sendCode({required String email});

  Future<CustomResponse> verifyForgotPassword({
    required String email,
    required String activationCode,
    required String password,
  });

  Future<CustomResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> logout();

  void setToken(String token);
}
