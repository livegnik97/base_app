import 'package:event_bus_riverpod/event_bus_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_app/core/constants/event_bus_constants.dart';
import 'package:base_app/core/firebase/firebase_manager.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/presentation/providers/conectivity_status/connectivity_status_provider.riverpod.dart';
import 'package:base_app/presentation/providers/lifecycle/lifecycle.provider.riverpod.dart';

final homeProvider = NotifierProvider.autoDispose<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

/// Provider de ejemplo que muestra los patrones comunes:
/// - escuchar cambios de conectividad con ref.listen
/// - escuchar eventos globales (event_bus_riverpod): notificaciones, lifecycle
class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    ref.onDispose(_dispose);

    //* escuchar cambios de conectividad
    ref.listen(connectivityStatusProvider, (prev, next) {
      final wasConnected = prev?.isConnected ?? false;
      if (!wasConnected && next.isConnected) {
        CustomPrint.call(
          'Home: conexión restaurada, type=${next.connectionType}',
        );
      } else if (wasConnected && !next.isConnected) {
        CustomPrint.call('Home: conexión perdida');
      }
    });

    //* escuchar el estado de pausa/reanudación de la app
    ref.listen(lifecycleProvider, (prev, next) {
      if (prev?.isPaused == true && !next.isPaused) {
        CustomPrint.call('Home: app reanudada');
      }
    });

    Future.delayed(Duration.zero, () async {
      await FirebaseManager.init();

      //* escuchar notificaciones pulsadas por el usuario
      ref
          .event(EventBusConstants.onNotificationTapped)
          .listen(_processNotification);

      //* escuchar cambios de ciclo de vida emitidos por lifecycleProvider
      ref.event(EventBusConstants.onAppLifecycleChanged).listen((isPaused) {
        if (!isPaused) _checkPendingNotification();
      });
    });

    return HomeState();
  }

  void _dispose() {}

  //* Procesar la notificación pulsada por el usuario.
  //* TODO: enrutar según el tipo/payload de la notificación de tu proyecto.
  void _processNotification(dynamic data) {
    try {
      CustomPrint.call('Home: notification tapped -> $data');
    } catch (_) {}
  }

  //* Revisar notificaciones que llegaron con la app en segundo plano.
  void _checkPendingNotification() {
    try {
      CustomPrint.call('Home: check pending notifications');
    } catch (_) {}
  }
}

class HomeState {}
