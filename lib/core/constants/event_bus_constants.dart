import 'package:event_bus_riverpod/event_bus_riverpod.dart';

class EventBusConstants {
  //* Constantes de los eventos globales usados con EventBusGlobal.
  //* Agregar aquí cada nuevo evento para evitar strings sueltos por el proyecto.

  //* para cuando la apk se pausa o se reanuda
  static final onAppLifecycleChanged = EventBusIdentifier<bool>(
    "onAppLifecycleChanged",
  );

  //* cuando se toca una notificacion
  static final onNotificationTapped = EventBusIdentifier<Map<String, dynamic>>(
    "onNotificationTapped",
  );

  //* cuando el usuario cierra sesión
  static final onUserLogout = EventBusIdentifier<bool>("onUserLogout");
}
