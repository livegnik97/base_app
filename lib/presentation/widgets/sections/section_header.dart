import 'package:flutter/material.dart';
import 'package:base_app/presentation/widgets/buttons/custom_text_button.dart';

/// Encabezado de sección con título y opcional botón de acción (ej. "Ver todo", "Limpiar").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.titleStyle,
    this.actionStyle,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final TextStyle? titleStyle;
  final TextStyle? actionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          CustomTextButton(
            label: actionLabel!,
            textStyle:
                actionStyle ?? TextStyle(color: colorScheme.onSurfaceVariant),
            onPressed: onAction,
          ),
      ],
    );
  }
}
