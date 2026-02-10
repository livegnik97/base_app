import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final socketioProvider =
    StateNotifierProvider.autoDispose<SocketioNotifier, SocketioState>((ref) {
      return SocketioNotifier();
    });

class SocketioNotifier extends StateNotifier<SocketioState> {
  late io.Socket _socket;

  SocketioNotifier() : super(SocketioState()) {
    init();
  }

  void init() async {
    final token = await MyShared.getStringOrNull(MySharedConstants.accessToken);
    _socket = io.io(Constants.socketIoUrlBase, {
      'transports': ['websocket'],
      'path': Constants.socketIoPath,
      if (token != null) 'extraHeaders': {'token': token},
    });
    _socket.onConnect((data) => state = state.copyWith(isConnected: true));
    _socket.onDisconnect((_) => state = state.copyWith(isConnected: false));
    initOns();
  }

  void sendMessage(String message) {
    _socket.emit('message', message);
  }

  void initOns() {
    _socket.on('listen', (data) {
      try {
        //* TODO to implement
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    try {
      _socket.disconnect();
    } catch (_) {}
    try {
      _socket.dispose();
    } catch (_) {}
    super.dispose();
  }
}

class SocketioState {
  final bool isConnected;

  SocketioState({this.isConnected = false});

  SocketioState copyWith({bool? isConnected}) {
    return SocketioState(isConnected: isConnected ?? this.isConnected);
  }
}
