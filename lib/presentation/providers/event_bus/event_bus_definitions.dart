part of "./event_bus_provider.dart";

// Definimos el tipo de callback genérico
typedef ListenerCallback<T> = void Function(T value);

class EventBus {
  //! NOTA LEER

  //* Cambiar a true para que el tipo T forme parte de la llave,
  //* esto permitiria utilizar el mismo evento para diferente tipos de datos

  //* Cambiar para false para usar la misma llave para todos los eventos
  //* sin importar el tipo de dato
  static final bool _strictUseTypeInBuildKey = false;

  // Mapa que guarda los listeners por tipo de evento/tag
  // final Map<String, List<dynamic>> _listeners = {};
  final Map<String, List<_ListenerEntry>> _listeners = {};

  // Método de suscripción que se integra con Riverpod
  void listen<T>(
    Ref ref,
    String eventName,
    ListenerCallback<T> callback, {
    bool autoDispose = true,
  }) {
    final key = _buildKey<T>(eventName);
    final entry = _ListenerEntry(callback);

    _listeners.putIfAbsent(key, () => []).add(entry);

    if (autoDispose) {
      // Se limpia automáticamente cuando el provider que se suscribió es destruido
      ref.onDispose(() {
        _removeListener(key, entry);
      });
    }
  }

  // Versión manual que devuelve un disposer
  ListenerDisposable on<T>(String eventName, ListenerCallback<T> callback) {
    final key = _buildKey<T>(eventName);
    final entry = _ListenerEntry(callback);

    _listeners.putIfAbsent(key, () => []).add(entry);

    return ListenerDisposable(() {
      _removeListener(key, entry);
    });
  }

  // Emitir evento
  void emit<T>(String eventName, T value) {
    final key = _buildKey<T>(eventName);
    final listeners = _listeners[key];

    if (listeners != null) {
      // Ejecutamos todos los callbacks
      for (final entry in List.from(listeners)) {
        if (!entry.isDisposed) {
          try {
            entry.callback(value);
            // (entry.callback as ListenerCallback<T>)(value);
          } catch (_) {}
        }
      }

      // Limpiamos listeners que se marcaron como desechados
      listeners.removeWhere((entry) => entry.isDisposed);
      if (listeners.isEmpty) {
        _listeners.remove(key);
      }
    }
  }

  void _removeListener(String key, _ListenerEntry entry) {
    entry.markAsDisposed();
    _listeners[key]?.remove(entry);
    if (_listeners[key]?.isEmpty ?? false) {
      _listeners.remove(key);
    }
  }

  // // Limpiar todos los listeners de un evento específico
  // void clearListeners<T>(String eventName) {
  //   final key = _buildKey<T>(eventName);
  //   _listeners.remove(key);
  // }

  String _buildKey<T>(String eventName) => '$eventName${_strictUseTypeInBuildKey ? ':${T.toString()}' : ''}';

  void clearAll() => _listeners.clear();
}

// Clase interna para trackear el estado de los listeners
class _ListenerEntry {
  final dynamic callback;
  bool isDisposed = false;

  _ListenerEntry(this.callback);

  void markAsDisposed() => isDisposed = true;
}

// Clase para manejar la disposición de listeners
class ListenerDisposable {
  final VoidCallback _dispose;

  ListenerDisposable(this._dispose);

  void dispose() => _dispose();

  // Para usar con extensiones de Riverpod
  // void close() => _dispose();
}
