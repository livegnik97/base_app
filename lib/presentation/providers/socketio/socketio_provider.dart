import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/constants/socketio_messages_constants.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final socketioProvider =
    NotifierProvider.autoDispose<SocketioNotifier, SocketioState>(
      SocketioNotifier.new,
    );

class SocketioNotifier extends Notifier<SocketioState> {
  io.Socket? _socket;

  bool _isInit = false;

  @override
  build() {
    ref.onDispose(_dispose);
    // init();
    return SocketioState();
  }

  void init() {
    if (_isInit) return;
    _isInit = true;
    if (_socket != null) {
      _dispose();
    }
    CustomPrint.call(
      'SocketioNotifier init url=${Constants.socketIoUrlBase} path=${Constants.socketIoPath}',
    );
    _socket = io.io(Constants.socketIoUrlBase, {
      'transports': ['websocket'],
      'path': Constants.socketIoPath,
    });
    _socket!.onConnect((data) async {
      CustomPrint.call(
        'SocketioNotifier onConnect transport=${_socket!.io.engine?.transport?.name ?? 'unknown'}',
      );
      state = state.copyWith(isConnected: true);
      emitLogin();
    });
    _socket!.onConnectError((data) {
      CustomPrint.call('SocketioNotifier onConnectError $data');
    });
    _socket!.onError((data) {
      CustomPrint.call('SocketioNotifier onError $data');
    });
    _socket!.onReconnectError((data) {
      CustomPrint.call('SocketioNotifier onReconnectError $data');
    });
    _socket!.onReconnectFailed((_) {
      CustomPrint.call('SocketioNotifier onReconnectFailed');
    });
    _socket!.onReconnectAttempt((attempt) {
      CustomPrint.call('SocketioNotifier onReconnectAttempt $attempt');
    });
    _socket!.onReconnect(
      (data) {
        CustomPrint.call('SocketioNotifier onReconnect');
      },
    );
    _socket!.onDisconnect((e) {
      CustomPrint.call('SocketioNotifier onDisconnect $e');
      return state = state.copyWith(isConnected: false);
    });
    _initOns();
  }

  Future<void> emitLogin([bool retry = true]) async {
    try {
      if (!state.isConnected) {
        CustomPrint.call('SocketioNotifier emitLogin skip: not connected');
        return;
      }
      final token = await MyShared.getStringOrNull(
        MySharedConstants.accessToken,
      );
      CustomPrint.call('SocketioNotifier emitLogin hasToken=${token != null}');
      if (token != null) {
        _socket?.emit(SocketIoMessagesConstants.emitLogin, {
          'accessToken': token,
        });
      }
    } catch (e) {
      CustomPrint.call('SocketioNotifier emitLogin error $e');
    }
  }

  Future<void> emitLogout() async {
    try {
      if (!state.isConnected) return;
      final userId = await MyShared.getStringOrNull(MySharedConstants.userId);
      if (userId != null) {
        _socket?.emit(SocketIoMessagesConstants.emitLogout, {'userId': userId});
      }
    } catch (_) {}
  }

  void sendMessage(String message) {
    _socket?.emit(SocketIoMessagesConstants.emitMessage, message);
  }

  void _initOns() {
    if (_socket == null) return;
    //* TODO: implementar los ons específicos del proyecto aquí
    _socket!.on(SocketIoMessagesConstants.onListen, (data) {
      try {
        _printLog(SocketIoMessagesConstants.onListen, data);
      } catch (_) {}
    });
  }

  void _printLog(String eventName, dynamic data) {
    CustomPrint.call('SocketioNotifier $eventName => $data');
  }

  void _dispose() {
    try {
      _socket?.disconnect();
    } catch (_) {}
    try {
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _isInit = false;
  }
}

class SocketioState {
  final bool isConnected;

  SocketioState({this.isConnected = false});

  SocketioState copyWith({bool? isConnected}) {
    return SocketioState(isConnected: isConnected ?? this.isConnected);
  }
}
