import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/providers/theme/theme_provider.riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeChangeWidget extends ConsumerWidget {
  const ThemeChangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return IconButton(
      icon: Icon(
        theme == 0
            ? context.isLightMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined
            : theme == 1
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
      ),
      onPressed: () => ref
          .read(themeProvider.notifier)
          .changeTheme(
            theme == 0
                ? context.isLightMode
                      ? 2
                      : 1
                : theme == 1
                ? 2
                : 1,
          ),
    );
  }
}
