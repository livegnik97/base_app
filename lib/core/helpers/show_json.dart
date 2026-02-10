import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';

import '../extensions/custom_context.dart';

class ShowJson {
  static Future<dynamic> show(
    BuildContext context,
    Map<String, dynamic> json, {
    String? title,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(top: context.height * .1),
      child: Container(
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
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
                    onPressed: () => Navigator.pop(context),
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
