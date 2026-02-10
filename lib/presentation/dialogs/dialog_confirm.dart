import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogConfirm extends StatelessWidget {
  const DialogConfirm({
    super.key,
    this.title,
    this.message,
    this.header,
    this.footer,
    this.subMessage,
    this.onConfirm,
    this.onCancel,
    this.onOtherOption,
    this.colorConfirmButton,
    this.colorCancelButton,
    this.aceptBottonText,
    this.cancelBottonText,
    this.showCancelOption = true,
    this.confirmAndBack = true,
    this.messageMaxLines,
  });

  final String? title;
  final String? message;
  final Widget? header;
  final Widget? footer;
  final String? subMessage;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onOtherOption;
  final Color? colorConfirmButton;
  final Color? colorCancelButton;
  final String? aceptBottonText;
  final String? cancelBottonText;
  final bool showCancelOption;
  final bool confirmAndBack;
  final int? messageMaxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50),
            child: header,
          ),
        if (title != null) ...[
          AutoSizeText(
            title!,
            style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            minFontSize: 1,
          ),
          const SizedBox(height: 16.0),
        ],
        if (message != null)
          AutoSizeText(
            message!,
            style: context.bodySmall.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: messageMaxLines ?? 10 - (subMessage != null ? 2 : 0),
            minFontSize: 1,
          ),
        if (footer != null)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50),
            child: footer,
          ),
        if (subMessage != null) ...[
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              subMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              minFontSize: 1,
            ),
          ),
        ],
        const SizedBox(height: 16.0),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: context.width * 0.6),
          child: CustomFilledButton(
            label: aceptBottonText ?? AppLocalizations.of(context)!.accept,
            height: 50,
            color: colorConfirmButton,
            onPressed: () async {
              if (confirmAndBack) {
                context.pop();
              }
              onConfirm?.call();
            },
          ),
        ),
        if (showCancelOption) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: context.width * 0.6),
            child: CustomOutlinedButton(
              label: cancelBottonText ?? AppLocalizations.of(context)!.cancel,
              height: 50,
              color: colorCancelButton,
              onPressed: () async {
                context.pop();
                onCancel?.call();
              },
            ),
          ),
        ],
      ],
    );
  }
}
