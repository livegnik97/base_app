import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/core/router/router.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Manejador global de errores no capturados (framework + root isolate).
///
/// Por defecto solo hace log local y encola los pendientes en SharedPreferences.
/// Para enviar los crash reports a un backend, asigna [GlobalErrorHandler.reportHandler].
class GlobalErrorHandler {
  /// Hook opcional para enviar el payload del crash a un backend propio.
  /// Debe lanzar una excepción si el envío falla (para reintentar luego).
  static Future<void> Function(Map<String, dynamic> payload)? reportHandler;

  static const String _pendingQueueKey = 'pendingCrashReports';
  static const int _maxQueue = 20;
  static const Duration _throttle = Duration(seconds: 5);
  static const Duration _sendTimeout = Duration(seconds: 5);

  static DateTime _lastSentAt = DateTime.fromMillisecondsSinceEpoch(0);
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;

    //* Errores del framework (build/render)
    FlutterError.onError = (FlutterErrorDetails details) {
      _handle(
        error: details.exception,
        stackTrace: details.stack ?? StackTrace.current,
        type: 'flutterError',
        isFatal: false,
      );
      //* en debug se mantiene la pantalla roja de Flutter para el desarrollo
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    //* Errores no capturados del root isolate (incluye asíncronos).
    //* Devolver true => se capturan en silencio y la app no se cierra.
    WidgetsBinding.instance.platformDispatcher.onError =
        (
          Object error,
          StackTrace stackTrace,
        ) {
          _handle(
            error: error,
            stackTrace: stackTrace,
            type: 'platformError',
            isFatal: true,
          );
          return true;
        };

    //* reintentar los crashes pendientes que no se pudieron enviar antes
    Future<void>.delayed(const Duration(seconds: 3), _flushPending);
  }

  static void _handle({
    required Object error,
    required StackTrace stackTrace,
    required String type,
    required bool isFatal,
  }) {
    try {
      CustomPrint.call(
        'GlobalErrorHandler[$type] -> $error\n${stackTrace.toString()}',
      );
      unawaited(_report(error, stackTrace, type, isFatal));
    } catch (_) {}
  }

  static Future<void> _report(
    Object error,
    StackTrace stackTrace,
    String type,
    bool isFatal,
  ) async {
    try {
      final now = DateTime.now();
      //* throttle para evitar un flood si el error ocurre en loop
      if (now.difference(_lastSentAt) < _throttle) {
        final payload = await _buildPayload(error, stackTrace, type, isFatal);
        await _enqueue(payload);
        return;
      }
      _lastSentAt = now;
      final payload = await _buildPayload(error, stackTrace, type, isFatal);
      await _trySend(payload);
    } catch (_) {}
  }

  static Future<void> _trySend(Map<String, dynamic> payload) async {
    final handler = reportHandler;
    if (handler == null) return;
    try {
      await handler(payload).timeout(_sendTimeout);
    } catch (_) {
      await _enqueue(payload);
    }
  }

  static Future<void> _enqueue(Map<String, dynamic> payload) async {
    try {
      final pending = await MyShared.getStringList(_pendingQueueKey, []);
      pending.add(jsonEncode(payload));
      if (pending.length > _maxQueue) {
        pending.removeRange(0, pending.length - _maxQueue);
      }
      await MyShared.setValue(_pendingQueueKey, pending);
    } catch (_) {}
  }

  static Future<void> _flushPending() async {
    try {
      final handler = reportHandler;
      if (handler == null) return;
      final pending = await MyShared.getStringList(_pendingQueueKey, []);
      if (pending.isEmpty) return;
      final remaining = <String>[];
      for (final raw in pending) {
        try {
          final payload = jsonDecode(raw) as Map<String, dynamic>;
          await handler(payload).timeout(_sendTimeout);
        } catch (_) {
          remaining.add(raw);
        }
      }
      await MyShared.setValue(_pendingQueueKey, remaining);
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> _buildPayload(
    Object error,
    StackTrace stackTrace,
    String type,
    bool isFatal,
  ) async {
    final deviceInfo = await _getDeviceInfo();
    final appVersion = await _getAppVersion();
    final userId = await MyShared.getStringOrNull(MySharedConstants.userId);
    String? route;
    try {
      route = appRouter.state.uri.toString();
    } catch (_) {}
    return <String, dynamic>{
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
      'type': type,
      'platform': Platform.operatingSystem,
      'appVersion': appVersion,
      'route': route,
      'deviceInfo': deviceInfo,
      'userId': userId,
      'isFatal': isFatal,
    };
  }

  static Future<String> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return '${info.manufacturer} ${info.model}, Android ${info.version.release} (${info.version.sdkInt})';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return '${info.model} (${info.modelName}), iOS ${info.systemVersion}';
      }
    } catch (_) {}
    return '';
  }

  static Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {}
    return '';
  }
}
