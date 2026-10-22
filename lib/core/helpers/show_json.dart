import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_view_plus/json_view_plus.dart';
import 'package:base_app/core/constants/constants.dart';

import '../extensions/custom_context.dart';

class ShowJson {
  static Future<dynamic> show(
    BuildContext context,
    Map<String, dynamic> json, {
    String? title,
  }) {
    if (!Constants.isDev) return Future.value(null);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(top: context.height * .1),
        child: Container(
          padding: const EdgeInsets.all(12),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, size: 24),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        title ?? "JSON Details",
                        style: context.titleLarge,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        minFontSize: 1,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                Expanded(child: JsonView(json: json)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
