import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_app/core/helpers/connectivity_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/*
  Modo de uso (Riverpod 3):
    - En otro provider escucha los cambios con ref.listen:
      ref.listen(connectivityStatusProvider, (prev, next) {
        if (next.isConnected) {
          // is connected (next.connectionType indica el tipo de red)
        } else {
          // connection lost
        }
      });

    - En cualquier parte del provider puedes saber si hay conexión a internet
      leyendo el estado: ref.read(connectivityStatusProvider).isConnected
      (también está .isNoConnected y .connectionType)

    - En el momento que necesites saber la conexión a internet en tiempo real
      se puede usar el siguiente método
      connectivityStatusNotifier.startInLiveChecked();
      Nota: puedes enviar por parámetro el tiempo de espera entre comprobaciones,
      por defecto es 3000 milisegundos

    - Y los siguientes métodos para detenerlo y para saber si está en tiempo real o no
      connectivityStatusNotifier.stopInLiveChecked();
      connectivityStatusNotifier.isInLiveChecked();

    - Usar el siguiente método para modificar el tiempo de espera entre comprobaciones
      setDelayedTimeInMilliseconds(5000)

    - Para el caso de estar conectado a una red pero no tener internet
      y no quieras habilitar el InLiveChecked puedes usar la siguiente variante
      Future<void> funcionX() async {
        try {
          if (ref.read(connectivityStatusProvider).isConnected) {
            // hacer la petición a internet
          }
        } catch (_) {
          // ante cualquier error que dé chequear la conexión
          await connectivityStatusNotifier.checkedConnection();
        }
      }
      Nota: En caso de estar conectado a una red pero no tener internet el
      servicio se quedará verificando la conexión periódicamente
*/

final connectivityStatusProvider =
    NotifierProvider.autoDispose<
      ConnectivityStatusNotifier,
      ConnectivityStatusState
    >(ConnectivityStatusNotifier.new);

class ConnectivityStatusNotifier extends Notifier<ConnectivityStatusState> {
  late ConnectivityStatus _connectivityStatus;

  @override
  build() {
    _connectivityStatus = ConnectivityStatus((
      bool isConnected,
      ConnectivityResult connectionType,
    ) {
      state = state.copyWith(
        isConnected: isConnected,
        connectionType: connectionType,
      );
    });
    return ConnectivityStatusState();
  }

  Future<void> checkedConnection([int delayed = -1]) async =>
      await _connectivityStatus.checkedConnection(delayed);

  void startInLiveChecked([int delayed = -1]) =>
      _connectivityStatus.startInLiveChecked(delayed);

  void stopInLiveChecked() => _connectivityStatus.stopInLiveChecked();

  bool isInLiveChecked() => _connectivityStatus.isInLiveChecked;

  void setDelayedTimeInMilliseconds(int delayed) =>
      _connectivityStatus.setDelayedTimeInMilliseconds(delayed);
}

class ConnectivityStatusState {
  final bool isConnected;
  final ConnectivityResult connectionType;

  ConnectivityStatusState({
    this.isConnected = false,
    this.connectionType = ConnectivityResult.none,
  });

  bool get isNoConnected => !isConnected;

  ConnectivityStatusState copyWith({
    bool? isConnected,
    ConnectivityResult? connectionType,
  }) {
    return ConnectivityStatusState(
      isConnected: isConnected ?? this.isConnected,
      connectionType: connectionType ?? this.connectionType,
    );
  }
}
