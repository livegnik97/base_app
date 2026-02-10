import 'dart:async';

import 'package:base_app/core/firebase/firebase_manager.dart';
import 'package:base_app/core/helpers/custom_log_print.dart';
import 'package:base_app/presentation/providers/conectivity_status/connectivity_status_provider.riverpod.dart';
import 'package:base_app/presentation/providers/socketio/socketio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) {
    final connectivityStatusNotifier = ref.read(
      connectivityStatusProvider.notifier,
    );
    final socketioNotifier = ref.read(socketioProvider.notifier);
    return HomeNotifier(connectivityStatusNotifier, socketioNotifier);
  },
);

class HomeNotifier extends StateNotifier<HomeState> {
  final ConnectivityStatusNotifier _connectivityStatusNotifier;
  late Function cancelConnectivityListen;

  final SocketioNotifier _socketioNotifier;
  late Function cancelSocketioListen;

  BuildContext? context;

  HomeNotifier(this._connectivityStatusNotifier, this._socketioNotifier)
    : super(HomeState()) {
    cancelConnectivityListen = _connectivityStatusNotifier.addListener((state) {
      if (state.isConnected) {
        CustomPrint.call('Is connected, type: ${state.connectionType}');
      } else {
        CustomPrint.call('Is disconnected');
      }
    });
    cancelSocketioListen = _socketioNotifier.addListener((state) {
      CustomPrint.call(
        'SocketioNotifier state isConnected: ${state.isConnected}',
      );
    });
    Future.delayed(Duration.zero, () async {
      await FirebaseManager.init();
      FirebaseManager.remoteSubscription =
          (String xxxId, bool byUser, {String? message}) {
            CustomPrint.call('New notification: $xxxId, $byUser, $message');
          };

      SystemChannels.lifecycle.setMessageHandler((msg) {
        if (msg == AppLifecycleState.resumed.toString()) {
          CustomPrint.call('AppLifecycleState.resumed');
        } else if (msg == AppLifecycleState.paused.toString()) {
          CustomPrint.call('AppLifecycleState.paused');
        }
        return Future.value(msg);
      });
    });
  }

  @override
  void dispose() {
    cancelConnectivityListen();
    cancelSocketioListen();
    FirebaseManager.remoteSubscription = null;
    super.dispose();
  }
}

class HomeState {}
