import 'package:base_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'custom_log_print.dart';

class ErrorManager {
  static String getErrorMessage(BuildContext context, ErrorModel errorModel) {
    String? errorType = errorModel.errorType;
    String? errorMessage = errorModel.errorMessage;
    String? defaultType = errorModel.defaultType;
    if (errorType == null && errorMessage == null && defaultType == null) {
      return "Error desconocido caso 1";
    }
    if (errorType != null || defaultType != null) {
      final String finalErrorType = errorType ?? defaultType!;
      switch (finalErrorType) {
        case ErrorType.noConnection:
          return AppLocalizations.of(context)!.errorType_noConnection;
        case ErrorType.noLogin:
          return AppLocalizations.of(context)!.errorType_noLogin;
        case ErrorType.authPermissionDenied:
        case ErrorType.authIncorrectCredentials:
        case ErrorType.authAccountNotActivated:
          return AppLocalizations.of(context)!.errorType_noAuth;
        case ErrorType.authIncorrectActivationCode:
          return AppLocalizations.of(
            context,
          )!.errorType_incorrectActivationCode;
        case ErrorType.noSendCode:
          return AppLocalizations.of(context)!.errorType_noSendCode;
        case ErrorType.userNotFound:
          return AppLocalizations.of(context)!.errorType_userNotFound;
        default:
          CustomPrint.call(
            "Desconocido errorType: $finalErrorType\nMensaje a mostrar: $errorMessage",
          );
          return Constants.isDev
              ? "Desconocido errorType: $finalErrorType\nMensaje a mostrar: $errorMessage"
              : (errorMessage ?? "Error desconocido");
      }
    }
    return errorMessage ?? "Error desconocido caso 2";
  }
}

class ErrorModel {
  final String? errorType;
  final String? errorMessage;
  final String? defaultType;

  ErrorModel({this.errorType, this.errorMessage, this.defaultType});
}

class ErrorType {
  static const String noConnection = "noConnection";
  static const String noLogin = "noLogin";
  static const String authPermissionDenied = "auth/permission-denied";
  static const String authIncorrectCredentials = "auth/incorrect-credentials";
  static const String authAccountNotActivated = "auth/account-not-activated";
  static const String authIncorrectActivationCode =
      "auth/incorrect-activation-code";
  static const String noSendCode = "noSendCode";
  static const String verifyPassword = "verifyPassword";
  static const String userNotFound = "user/not-found";
}
