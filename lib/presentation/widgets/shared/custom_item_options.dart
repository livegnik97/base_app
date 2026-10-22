import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:base_app/core/extensions/color_extension.dart';

import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';

class CustomItemOptions extends StatelessWidget {
  CustomItemOptions({
    super.key,
    required this.children,
    this.title,
    this.trailing,
    this.color,
    this.useSameTextSize = false,
  });

  final String? title;
  final Widget? trailing;
  final List<CItemAbstract> children;
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  final Color? color;
  final bool useSameTextSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || trailing != null)
          Padding(
            padding: EdgeInsets.only(bottom: trailing == null ? 12 : 0),
            child: Row(
              children: <Widget>[
                if (title != null)
                  Expanded(
                    child: AutoSizeText(
                      title!.toUpperCase(),
                      style: context.labelSmall.copyWith(
                        color: context.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      minFontSize: 1,
                    ),
                  )
                else
                  Spacer(),
                ?trailing,
              ],
            ),
          ),
        CustomContainer(
          color: color,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < children.length; i++)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    children[i]._child(
                      context,
                      useSameTextSize ? _autoSizeGroup : null,
                    ),
                    if (i != children.length - 1 && children.length > 1)
                      Divider(
                        height: 1,
                        color: context.outlineVariant.withValues(alpha: 0.5),
                        indent: 20,
                        endIndent: 20,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

abstract class CItemAbstract {
  Widget _child(BuildContext context, AutoSizeGroup? autoSizeGroup);
}

class CItemCustom extends CItemAbstract {
  final Widget child;

  CItemCustom({
    required this.child,
  });

  @override
  Widget _child(_, _) => child;
}

class CItemText extends CItemAbstract {
  final String label;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? leading;
  final Widget? trailing;
  final int? trailingBadgetCount;
  final Widget? bottom;
  final Color? color;
  final Color? backgroundColor;

  CItemText({
    required this.label,
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    this.leading,
    this.trailing,
    this.trailingBadgetCount,
    this.bottom,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget _child(BuildContext context, AutoSizeGroup? autoSizeGroup) {
    return Column(
      children: [
        Material(
          color: backgroundColor ?? Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Row(
                spacing: 8,
                children: [
                  if (leadingIcon != null)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            color?.withOpacity2(.2) ??
                            context.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        leadingIcon,
                        size: 16,
                        color:
                            color?.withOpacity2(.8) ?? context.onSurfaceVariant,
                      ),
                    ),
                  ?leading,
                  Expanded(
                    child: AutoSizeText(
                      label,
                      group: autoSizeGroup,
                      style: context.titleMedium.copyWith(color: color),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 1,
                    ),
                  ),
                  ?trailing,

                  if (trailingBadgetCount != null)
                    Badge.count(
                      count: trailingBadgetCount!,
                      padding: EdgeInsets.all(4),
                      textColor: color ?? context.onSurface,
                      backgroundColor:
                          color?.withOpacity2(.2) ??
                          context.surfaceContainerLow,
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (trailingIcon != null)
                    Icon(
                      trailingIcon,
                      color:
                          color?.withOpacity2(.8) ?? context.onSurfaceVariant,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ),
        ?bottom,
      ],
    );
  }
}

class CItemSwitch extends CItemAbstract {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? leading;
  final Widget? trailing;
  final int? trailingBadgetCount;
  final Widget? bottom;

  CItemSwitch({
    required this.value,
    required this.onChanged,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.leading,
    this.trailing,
    this.trailingBadgetCount,
    this.bottom,
  });

  @override
  Widget _child(BuildContext context, AutoSizeGroup? autoSizeGroup) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: SwitchListTile(
            value: value,
            onChanged: onChanged,
            title: Row(
              spacing: 8,
              children: [
                if (leadingIcon != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      leadingIcon,
                      size: 16,
                      color: context.onSurfaceVariant,
                    ),
                  ),
                ?leading,
                Expanded(
                  child: AutoSizeText(
                    label,
                    group: autoSizeGroup,
                    style: context.titleMedium,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    minFontSize: 1,
                  ),
                ),
                ?trailing,

                if (trailingBadgetCount != null)
                  Badge.count(
                    count: trailingBadgetCount!,
                    padding: EdgeInsets.all(4),
                    textColor: context.onSurface,
                    backgroundColor: context.surfaceContainer,
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (trailingIcon != null)
                  Icon(
                    trailingIcon,
                    color: context.onSurfaceVariant,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
        ?bottom,
      ],
    );
  }
}
