import 'package:flutter/material.dart';

class KeyboardManager {
  static void close(BuildContext context) {
    try {
      FocusScope.of(context).unfocus();
    } catch (_) {}
  }
}
