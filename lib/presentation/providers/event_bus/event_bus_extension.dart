part of "./event_bus_provider.dart";

extension EventBusRef on Ref {
  // Escucha automática con limpieza
  void listenToEvent<T>({
    required String eventName,
    required ListenerCallback<T> callback,
  }) {
    final bus = read(eventBusProvider);
    bus.listen(this, eventName, callback);
  }

  // Escucha manual que devuelve disposer
  ListenerDisposable listenToEventManually<T>({
    required String eventName,
    required ListenerCallback<T> callback,
  }) {
    final bus = read(eventBusProvider);
    return bus.on(eventName, callback);
  }

  void emitEvent<T>(String eventName, T value) {
    read(eventBusProvider).emit(eventName, value);
  }
}

extension EventBusEmit on WidgetRef {
  // Escucha manual que devuelve disposer
  ListenerDisposable listenToEventManually<T>({
    required String eventName,
    required ListenerCallback<T> callback,
  }) {
    final bus = read(eventBusProvider);
    return bus.on(eventName, callback);
  }

  void emitEvent<T>(String eventName, T value) {
    read(eventBusProvider).emit(eventName, value);
  }
}
