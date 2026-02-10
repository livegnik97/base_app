import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';

class CustomInmutableText extends StatelessWidget {
  const CustomInmutableText({
    super.key,
    required this.title,
    this.subTitle,
    this.icon,
    this.onActionPressed,
    this.tooltip,
    this.onDelete,
    this.backgroundColor,
  });
  final String title;
  final String? subTitle;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final VoidCallback? onDelete;
  final String? tooltip;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      withBorder: true,
      child: ListTile(
        tileColor: context.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        title: Text(title),
        subtitle: subTitle != null ? Text(subTitle!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: context.error),
                tooltip: AppLocalizations.of(context)!.delete,
              ),

            if (onActionPressed != null && icon != null)
              IconButton(
                onPressed: onActionPressed,
                icon: Icon(icon),
                tooltip: tooltip,
              ),
          ],
        ),
      ),
    );
  }
}
