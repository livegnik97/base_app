import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_app/core/constants/constants.dart';

class KeepAliveProvider {
  final Ref ref;
  final Duration timeOut;
  final VoidCallback? onDispose;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  KeepAliveProvider({
    required this.ref,
    this.timeOut = const Duration(seconds: 10),
    this.onDispose,
    this.onPause,
    this.onResume,
  }) {
    _init();
  }

  void _init() {
    try {
      Timer? timer;
      ref.onDispose(() {
        // CustomPrint.call('npcLogs onDispose ${timer?.isActive}');
        timer?.cancel();
        onDispose?.call();
      });
      if (Constants.ignoreKeepAliveProvider) return;
      final link = ref.keepAlive();
      ref.onCancel(() {
        // print('npcLogs onCancel');
        timer = Timer(timeOut, () {
          // CustomPrint.call('npcLogs onCancel timeOut');
          link.close();
        });
        onPause?.call();
      });
      ref.onResume(() {
        // CustomPrint.call('npcLogs onResume ${timer?.isActive}');
        timer?.cancel();
        onResume?.call();
      });
    } catch (_) {}
  }
}
