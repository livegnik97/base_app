import 'package:flutter/services.dart';

class ClipboardManager {
  static Future<void> copyText(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }
}
