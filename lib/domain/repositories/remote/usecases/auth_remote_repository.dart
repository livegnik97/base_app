import 'package:base_app/data/dio/custom_response.dart';
import 'package:base_app/domain/entities/login_entity.dart';
import 'package:base_app/domain/repositories/remote/dtos/change_password_dto.dart';
import 'package:base_app/domain/repositories/remote/dtos/login_dto.dart';
import 'package:base_app/domain/repositories/remote/dtos/register_user_dto.dart';

abstract class AuthRemoteRepository {
  Future<CustomResponse<LoginEntity>> login(LoginDto dto);

  Future<CustomResponse> register(RegisterUserDto dto);

  Future<CustomResponse> resendVerificationCode({required String email});

  Future<CustomResponse> sendCode({required String email});

  Future<CustomResponse> verifyForgotPassword({
    required String email,
    required String activationCode,
    required String password,
  });

  Future<CustomResponse> changePassword(ChangePasswordDto dto);

  Future<CustomResponse> logout();

  void setToken(String token);
}
