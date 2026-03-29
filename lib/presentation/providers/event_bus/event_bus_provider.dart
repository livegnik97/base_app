import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part './event_bus_extension.dart';
part './event_bus_definitions.dart';
part './event_bus_constants.dart';

// El provider que manejará las suscripciones
final eventBusProvider = Provider<EventBus>((ref) {
  final bus = EventBus();

  // Auto-limpieza cuando el provider sea destruido
  ref.onDispose(() {
    bus.clearAll();
  });

  return bus;
});
