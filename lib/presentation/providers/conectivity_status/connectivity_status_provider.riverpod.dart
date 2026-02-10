import 'dart:async';

import 'package:base_app/core/helpers/connectivity_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

/*
  Modo de uso:
    - Instalar las librerías: connectivity_plus, dio

    - En otro provider obtén el notifier
    final connectivityStatusNotifier = ref.watch(connectivityStatusProvider.notifier);

    - En el constructor del notifier de ese provider puedes usar
    connectivityStatusNotifier.addListener((connectivityStatusState) {
      print("Hay conexión: ${connectivityStatusState.isConnected ? "si" : "no"}");
      if (connectivityStatusState.isConnected) {
        // is connected
      } else {
        // connection lost
      }
    });

    - En cualquier parte del provider puedes saber si hay conexión a internet usando
    connectivityStatusNotifier.isConnected

    - También saber el tipo de conexión con
    connectivityStatusNotifier.connectionType
    Nota: debes entrar a la clase ConnectivityResult para saber el tipo de conexión

    - En el momento que necesites saber la conexión a internet en tiempo real
    se puede usar el siguiente método
    connectivityStatusNotifier.startInLiveChecked();
    Nota: puedes enviar por parámetro el tiempo de espera entre comprobaciones,
    por defecto es 3000 milisegundos

    - Y los siguientes métodos para detenerlo y para saber si está en tiempo real o no
    connectivityStatusNotifier.stopInLiveChecked();
    connectivityStatusNotifier.isInLiveChecked;

    - Usar el siguiente método para modificar el tiempo de espera entre comprobaciones
    setDelayedTimeInMilliseconds(5000)

    - Para el caso de estar conectado a una red pero no tener internet
    y no quieras habilitar el InLiveChecked puedes usar la siguiente variante
    Future<void> funcionX() async {
      try {
        if (connectivityStatusNotifier.isConnected) {
          // hacer la petición a internet
        }
      } catch (_) {
        // ante cualquier error que dé chequear la conexión
        connectivityStatusNotifier.checkedConnection();
      }
    }
    Nota: En caso de estar conectado a una red pero no tener internet el
    servicio se quedará verificando la conexión periódicamente
*/

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatusState>(
      (ref) => ConnectivityStatusNotifier(),
    );

class ConnectivityStatusNotifier
    extends StateNotifier<ConnectivityStatusState> {
  late ConnectivityStatus connectivityStatus;

  ConnectivityStatusNotifier() : super(ConnectivityStatusState()) {
    connectivityStatus = ConnectivityStatus((
      bool isConnected,
      ConnectivityResult connectionType,
    ) {
      state = state.copyWith(
        isConnected: isConnected,
        connectionType: connectionType,
      );
    });
  }

  Future<void> checkedConnection([int delayed = -1]) async =>
      await connectivityStatus.checkedConnection(delayed);

  void startInLiveChecked([int delayed = -1]) =>
      connectivityStatus.startInLiveChecked(delayed);

  void stopInLiveChecked() => connectivityStatus.stopInLiveChecked();

  bool get isInLiveChecked => connectivityStatus.isInLiveChecked;

  void setDelayedTimeInMilliseconds(int delayed) =>
      connectivityStatus.setDelayedTimeInMilliseconds(delayed);

  bool get isConnected => state.isConnected;
  bool get isNoConnected => !isConnected;
  ConnectivityResult get connectionType => state.connectionType;
}

class ConnectivityStatusState {
  final bool isConnected;
  final ConnectivityResult connectionType;

  ConnectivityStatusState({
    this.isConnected = false,
    this.connectionType = ConnectivityResult.none,
  });

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
