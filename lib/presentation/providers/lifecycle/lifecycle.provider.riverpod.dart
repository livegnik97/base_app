import 'dart:ui';

import 'package:event_bus_riverpod/event_bus_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_app/core/constants/event_bus_constants.dart';

final lifecycleProvider =
    NotifierProvider.autoDispose<LifecycleNotifier, LifecycleState>(
      LifecycleNotifier.new,
    );

class LifecycleNotifier extends Notifier<LifecycleState> {
  @override
  LifecycleState build() {
    Future.delayed(Duration.zero, () {
      SystemChannels.lifecycle.setMessageHandler((msg) {
        if (msg == AppLifecycleState.resumed.toString()) {
          state = state.copyWith(isPaused: false);
          ref
              .event(EventBusConstants.onAppLifecycleChanged)
              .emit(state.isPaused);
        } else if (msg == AppLifecycleState.paused.toString()) {
          state = state.copyWith(isPaused: true);
          ref
              .event(EventBusConstants.onAppLifecycleChanged)
              .emit(state.isPaused);
        }
        return Future.value(msg);
      });
    });
    return LifecycleState();
  }
}

class LifecycleState {
  final bool isPaused;
  LifecycleState({
    this.isPaused = false,
  });

  LifecycleState copyWith({
    bool? isPaused,
  }) {
    return LifecycleState(
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
