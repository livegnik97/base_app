import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'custom_log_print.dart';

class ConnectivityStatus {
  final Function(bool, ConnectivityResult) _onChangeConnection;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? subscription;

  bool _isConnected = false;
  ConnectivityResult _lastConnectivityResult = ConnectivityResult.none;
  bool _canCheckedConnection = true;
  bool _keepAlive = false;
  int _delayedMilliseconds = -1;

  ConnectivityStatus(this._onChangeConnection) {
    subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  bool get isConnected => _isConnected;
  ConnectivityResult get connectionType => _lastConnectivityResult;

  Future<void> _updateConnectionStatus(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (connectivityResult.isEmpty ||
        connectivityResult.first == ConnectivityResult.none) {
      if (_isConnected) {
        _isConnected = false;
        _onChangeConnection(_isConnected, ConnectivityResult.none);
      }
    } else {
      final firstConnectivityResult = connectivityResult.first;
      final hasConnection = await _isRealConnection();
      if (hasConnection) {
        if (!_isConnected ||
            firstConnectivityResult != _lastConnectivityResult) {
          _isConnected = true;
          _onChangeConnection(_isConnected, firstConnectivityResult);
        }
      } else {
        if (_isConnected ||
            firstConnectivityResult != _lastConnectivityResult) {
          _isConnected = false;
          _onChangeConnection(_isConnected, firstConnectivityResult);
        }
        checkedConnection();
      }
    }
    if (connectivityResult.isNotEmpty) {
      _lastConnectivityResult = connectivityResult.first;
    }
  }

  Future<bool> _isRealConnection() async {
    List<String> urlsToCheck = [
      'https://www.google.com/',
      'https://portal.ultradns.com/',
      'https://www.cloudflare.com/',
      'https://www.facebook.com/',
      'https://www.instagram.com/',
      'https://easydns.com/',
      'https://support.norton.com/',
      'https://www.yahoo.com/',
    ];
    for (String url in urlsToCheck) {
      try {
        await Dio().get(url);
        return true;
      } on DioException catch (e) {
        CustomPrint.call(
          "DioException in _isRealConnection: ${e.message} to $url",
        );
      }
    }
    return false;
  }

  Future<void> checkedConnection([int delayed = -1]) async {
    if (delayed >= 0) {
      setDelayedTimeInMilliseconds(delayed);
    }
    if (!_canCheckedConnection) return;
    _canCheckedConnection = false;
    List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty) {
      connectivityResult.add(ConnectivityResult.none);
    }
    await _updateConnectionStatus(connectivityResult);
    if ((_isConnected == false &&
            _lastConnectivityResult != ConnectivityResult.none) ||
        _keepAlive) {
      Future.delayed(
        Duration(
          milliseconds: _delayedMilliseconds >= 0 ? _delayedMilliseconds : 3000,
        ),
        () {
          _canCheckedConnection = true;
          checkedConnection();
        },
      );
    } else {
      _canCheckedConnection = true;
    }
  }

  void startInLiveChecked([int delayed = -1]) {
    _keepAlive = true;
    checkedConnection(delayed);
  }

  void stopInLiveChecked() {
    _keepAlive = false;
  }

  bool get isInLiveChecked => _keepAlive;

  void setDelayedTimeInMilliseconds(int delayed) {
    _delayedMilliseconds = delayed;
  }
}
