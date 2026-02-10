import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/providers/language/locale_provider.riverpod.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogSelectLanguage extends ConsumerWidget {
  const DialogSelectLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoSizeText(
          AppLocalizations.of(context)!.selectLanguage,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 2,
          minFontSize: 1,
        ),
        const SizedBox(height: 16),
        AutoSizeText(
          AppLocalizations.of(context)!.selectLanguageDetails,
          style: context.bodySmall.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
          maxLines: 4,
          minFontSize: 1,
        ),
        const SizedBox(height: 16),
        ...L10n.all.map((locale) {
          final flag = L10n.getFlag(locale.languageCode);
          final label = L10n.getLanguageLabel(context, locale.languageCode);
          return Padding(
            padding: const EdgeInsets.all(4),
            child: InkWell(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(locale);
              },
              child: AnimatedContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                  color: localeState.locale == locale
                      ? context.primary.withAlpha((255 * .2).toInt())
                      : null,
                ),
                child: Text("$flag $label"),
              ),
            ),
          );
        }),

        const SizedBox(height: 16.0),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: context.width * 0.6),
          child: CustomFilledButton(
            label: AppLocalizations.of(context)!.accept,
            height: 50,
            onPressed: () async {
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
