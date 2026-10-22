import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/data/dio/custom_response.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'custom_log_print.dart';

class ErrorManager {
  static String getErrorMessage(BuildContext context, ErrorModel errorModel) {
    String? errorType = errorModel.errorType;
    String? errorMessage = errorModel.errorMessage;
    String? defaultType = errorModel.defaultType;
    if (errorType == null && errorMessage == null && defaultType == null) {
      return "Unknown error type 1";
    }
    if (errorType != null || defaultType != null) {
      final String finalErrorType = errorType ?? defaultType!;
      switch (finalErrorType) {
        //* Tipos locales
        case ErrorType.noConnection:
          return context.l10n.errorType_noConnection;
        case ErrorType.paginationIndexOfBounds:
          return context.l10n.errorType_paginationIndexOfBounds;
        case ErrorType.invalidForm:
          return context.l10n.errorType_invalidForm;

        //* Login / registro (compatibilidad con el backend base)
        case ErrorType.noLogin:
          return context.l10n.errorType_noLogin;
        case ErrorType.authPermissionDenied:
        case ErrorType.authIncorrectCredentials:
        case ErrorType.authAccountNotActivated:
          return context.l10n.errorType_noAuth;
        case ErrorType.authIncorrectActivationCode:
          return context.l10n.errorType_incorrectActivationCode;
        case ErrorType.noSendCode:
          return context.l10n.errorType_noSendCode;

        //* Errores generales del servidor
        case ErrorType.unknownError:
          return context.l10n.errorType_unknownError;
        case ErrorType.error:
          return context.l10n.errorType_error;
        case ErrorType.createError:
          return context.l10n.errorType_createError;
        case ErrorType.alreadyExists:
          return context.l10n.errorType_alreadyExists;
        case ErrorType.notFound:
          return context.l10n.errorType_notFound;
        case ErrorType.updateOrDeleteViolatesForeignKey:
          return context.l10n.errorType_updateOrDeleteViolatesForeignKey;
        case ErrorType.emptyFields:
          return context.l10n.errorType_emptyFields;
        case ErrorType.errorSaveFile:
          return context.l10n.errorType_errorSaveFile;
        case ErrorType.invalidField:
          return context.l10n.errorType_invalidField;
        case ErrorType.errorCompressImage:
          return context.l10n.errorType_errorCompressImage;
        case ErrorType.noFileUploaded:
          return context.l10n.errorType_noFileUploaded;
        case ErrorType.errorSendMail:
          return context.l10n.errorType_errorSendMail;

        //* Usuarios / permisos
        case ErrorType.userNotActive:
          return context.l10n.errorType_userNotActive;
        case ErrorType.userIsBlocked:
          return context.l10n.errorType_userIsBlocked;
        case ErrorType.userOrPasswordIncorrect:
          return context.l10n.errorType_userOrPasswordIncorrect;
        case ErrorType.unauthorized:
          return context.l10n.errorType_unauthorized;
        case ErrorType.insufficientPermissions:
          return context.l10n.errorType_insufficientPermissions;
        case ErrorType.userNotFound:
          return context.l10n.errorType_userNotFound;
        case ErrorType.userNotConnected:
          return context.l10n.errorType_userNotConnected;
        case ErrorType.userDoesNotMeetRequirements:
          return context.l10n.errorType_userDoesNotMeetRequirements;
        case ErrorType.incorrectGoogleVerification:
          return context.l10n.errorType_incorrectGoogleVerification;
        case ErrorType.incorrectGoogleClientId:
          return context.l10n.errorType_incorrectGoogleClientId;

        case ErrorType.serviceNotAvailable:
          return context.l10n.errorType_serviceNotAvailable;

        default:
          CustomPrint.call(
            "Desconocido errorType: $finalErrorType\nMensaje a mostrar: $errorMessage",
          );
          return Constants.isDev
              ? "Desconocido errorType: $finalErrorType\nMensaje a mostrar: $errorMessage"
              : (errorMessage ?? "Unknown error type 3");
      }
    }
    return errorMessage ?? "Unknown error type 2";
  }
}

class ErrorModel {
  final String? errorType;
  final String? errorMessage;
  final String? defaultType;

  ErrorModel({this.errorType, this.errorMessage, this.defaultType});

  factory ErrorModel.parse(CustomResponse res) {
    try {
      //* Error cuando no esta logueado e intenta acceder a una ruta que requiere loguearse o no tiene permisos
      if (res.type == null && res.statusCode == 401) {
        return ErrorModel(
          errorType: ErrorType.unauthorized,
          errorMessage: res.message,
        );
      }

      //* Error de los Dto cuando alguno de los campos no tiene el formato correcto, la primera palabra es el campo con error
      if (res.error?['message'] is List) {
        try {
          final errorList = (res.error['message'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
          return ErrorModel(
            errorType: ErrorType.formError,
            errorMessage: errorList.isEmpty
                ? res.message
                : errorList.join(', '),
          );
        } catch (_) {}
      }

      //* Errores generales
      return ErrorModel(
        errorType: res.type,
        errorMessage: res.message,
        defaultType: ErrorType.unknownError,
      );
    } catch (e) {
      return ErrorModel(
        defaultType: ErrorType.unknownError,
        errorMessage: "$e",
      );
    }
  }
}

class ErrorType {
  //* Tipos de errores locales
  static const String noConnection = "noConnection";
  static const String paginationIndexOfBounds = "paginationIndexOfBounds";
  static const String invalidForm = "invalidForm";

  //* Tipo del dto para los formularios
  static const String formError = "formError";

  //* Tipos de errores del login (compatibilidad con el backend base)
  static const String noLogin = "noLogin";
  static const String authPermissionDenied = "auth/permission-denied";
  static const String authIncorrectCredentials = "auth/incorrect-credentials";
  static const String authAccountNotActivated = "auth/account-not-activated";
  static const String authIncorrectActivationCode =
      "auth/incorrect-activation-code";
  static const String noSendCode = "noSendCode";

  //* Tipos de errores manejados del servidor
  static const String unknownError = 'unknown_error';
  static const String error = 'error';
  static const String createError = 'create_error';
  static const String alreadyExists = 'already_exists';
  static const String notFound = 'not_found';
  static const String updateOrDeleteViolatesForeignKey =
      'update_or_delete_violates_foreign_key';
  static const String emptyFields = 'empty_fields';
  static const String errorSaveFile = 'error_save_file';
  static const String invalidField = 'invalid_field';
  static const String errorCompressImage = 'error_compress_image';
  static const String noFileUploaded = 'no_file_uploaded';
  static const String errorSendMail = 'error_send_mail';
  static const String userNotActive = 'user_not_active';
  static const String userIsBlocked = 'user_is_blocked';
  static const String userOrPasswordIncorrect = 'user_or_password_incorrect';
  static const String unauthorized = 'unauthorized';
  static const String insufficientPermissions = 'insufficient_permissions';
  static const String userNotFound = 'user_not_found';
  static const String userNotConnected = 'user_not_connected';
  static const String userDoesNotMeetRequirements =
      'user_does_not_meet_requirements';
  static const String incorrectGoogleVerification =
      'incorrect_google_verification';
  static const String incorrectGoogleClientId = 'incorrect_google_client_id';
  static const String serviceNotAvailable = 'service_not_available';
}
