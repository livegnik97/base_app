import 'package:flutter/material.dart';
import 'package:base_app/core/constants/constants.dart';

/// Fila reutilizable: leading (icono/avatar), título, subtítulo opcional y trailing opcional.
/// [subtitleStyle] permite marcar alertas/errores. [onTap] para fila tappable.
class IconTitleSubtitleRow extends StatelessWidget {
  const IconTitleSubtitleRow({
    super.key,
    this.leading,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
    this.onTap,
    this.padding,
    this.leadingSize = 48,
  });

  /// Widget personalizado a la izquierda (avatar, imagen, etc.). Si null y [icon] no null, se usa un contenedor con icono.
  final Widget? leading;

  /// Icono mostrado en un contenedor redondeado si [leading] es null.
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  /// Estilo del título (ej. color error para alertas).
  final TextStyle? titleStyle;

  /// Estilo del subtítulo (ej. color error para alertas).
  final TextStyle? subtitleStyle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double leadingSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveLeading =
        leading ??
        (icon != null
            ? Container(
                width: leadingSize,
                height: leadingSize,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(
                    Constants.borderRadius - 4,
                  ),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onSurface,
                  size: leadingSize * 0.5,
                ),
              )
            : null);

    final content = Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (effectiveLeading != null) ...[
            effectiveLeading,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style:
                      titleStyle ??
                      theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style:
                        subtitleStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        child: content,
      );
    }
    return content;
  }
}
