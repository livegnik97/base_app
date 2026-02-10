// ignore_for_file: equal_elements_in_set

import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/core/helpers/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ErrorDioDescription extends StatelessWidget {
  final RequestOptions? request;
  final DioException err;
  const ErrorDioDescription({super.key, required this.err, this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              String cad = '';
              try {
                cad += 'REQUEST[${request?.method}] => PATH: ${request?.path}';
                cad += "\n";
                cad += 'REQUEST => DATA: ${request?.data}';
                cad += "\n";
                cad += "\n";
                cad +=
                    'RESPONSE[${err.response?.statusCode}] => DATA: ${err.response?.data}';
                cad += "\n";
                cad += "\n";
                cad += 'APK ERROR => ${err.toString()}';
              } catch (_) {
                cad += "Error copiando la info";
              }
              ClipboardManager.copyText(cad);
            },
            child: const Icon(Icons.copy),
          ),
          body: Column(
            children: [
              Row(
                children: <Widget>[
                  const SizedBox(width: 30),
                  Expanded(
                    child: AutoSizeText(
                      "¡ERROR!",
                      style: context.titleLarge,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 1,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 30),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      AutoSizeText(
                        "REQUEST",
                        style: context.titleMedium,
                        maxLines: 1,
                        minFontSize: 1,
                      ),
                      const SizedBox(height: 12),
                      if (request == null) const Text("no-request"),
                      if (request != null) ...{
                        Text("Path: ${request!.path}"),
                        const SizedBox(height: 8),
                        Text("Method: ${request!.method}"),
                        if (request!.queryParameters.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Query parameters: ${request!.queryParameters.toString()}",
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text("Data: ${request!.data?.toString()}"),
                      },
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 12),
                      AutoSizeText(
                        "RESPONSE",
                        style: context.titleMedium,
                        maxLines: 1,
                        minFontSize: 1,
                      ),
                      const SizedBox(height: 12),
                      if (err.response == null) const Text("no-response"),
                      if (err.response != null) ...[
                        Text('Status Code: ${err.response!.statusCode}'),
                        const SizedBox(height: 8),
                        Text('DATA: ${err.response!.data}'),
                      ],
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 12),
                      AutoSizeText(
                        "APK ERROR",
                        style: context.titleMedium,
                        maxLines: 1,
                        minFontSize: 1,
                      ),
                      const SizedBox(height: 12),
                      Text(err.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
