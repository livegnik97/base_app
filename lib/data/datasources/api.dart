import 'dart:io';

import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/domain/repositories/remote/remote_repository.dart';
import 'package:base_app/domain/repositories/remote/usecases/auth_remote_repository.dart';
import 'package:base_app/domain/repositories/remote/usecases/user_remote_repository.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../dio/my_dio.dart';
import '../shared_preferences/my_shared.dart';
import 'usecases/auth_endpoints.dart';
import 'usecases/user_endpoints.dart';

class ApiConsumer extends RemoteRepository {
  static final RemoteRepository _instace = ApiConsumer._();
  late MyDio _myDio;

  static RemoteRepository getInstance() => _instace;

  //* usecases
  late AuthEndpoints _authEndpoints;
  late UserEndpoints _userEndpoints;

  ApiConsumer._() {
    _myDio = MyDio(Constants.baseUrlApi);

    //* usecases
    _authEndpoints = AuthEndpoints(_myDio);
    _userEndpoints = UserEndpoints(_myDio);

    _initLanguage();
    _initInfoDevice();

    //* restore token on startup
    _restoreToken();
  }

  void _initLanguage() async {
    try {
      final locale = await MyShared.getString(
        MySharedConstants.languageSelect,
        L10n.all[0].languageCode,
      );
      _myDio.updateLanguage(locale);
    } catch (_) {}
  }

  void _initInfoDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        String infoDevice = '';
        if (androidInfo.name.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += androidInfo.name;
        }
        if (androidInfo.model.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += androidInfo.model;
        }
        if (androidInfo.brand.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += androidInfo.brand;
        }
        if (androidInfo.id.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += 'ID: ${androidInfo.id}';
        }
        if (androidInfo.version.release.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice +=
              'Android: ${androidInfo.version.release} (${androidInfo.version.sdkInt})';
        }
        _myDio.updateInfoDevice(infoDevice);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        String infoDevice = '';
        if (iosInfo.name.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += iosInfo.name;
        }
        if (iosInfo.model.isNotEmpty || iosInfo.modelName.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += '${iosInfo.model} (${iosInfo.modelName})';
        }
        if (iosInfo.systemVersion.isNotEmpty) {
          if (infoDevice.isNotEmpty) {
            infoDevice += ', ';
          }
          infoDevice += 'System version: ${iosInfo.systemVersion}';
        }
        _myDio.updateInfoDevice(infoDevice);
      }
    } catch (_) {}
  }

  Future<void> _restoreToken() async {
    final token = await MyShared.getStringOrNull(MySharedConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      _myDio.updateToken(token);
    }
  }

  @override
  AuthRemoteRepository get auth => _authEndpoints;

  @override
  UserRemoteRepository get user => _userEndpoints;
}
