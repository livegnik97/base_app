import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

extension IconToImage on IconData {
  Future<Uint8List?> toImage({int size = 48, Color? color}) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(codePoint);
    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: size.toDouble(),
        fontFamily: fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size, size);
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    final result = bytes?.buffer.asUint8List();

    return result;
  }
}
