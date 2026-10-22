import 'package:flutter/material.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/core/helpers/vibration_manager.dart';

class CustomPopupMenu {
  //Usar PopupMenuItem para opciones normales del menu
  static void show(BuildContext context, List<PopupMenuEntry> actions) {
    if (actions.isEmpty) return;
    VibrationManager.vibrate();
    final position = context.currentWidgetPosition;
    showMenu(
      context: context,
      items: actions,
      // menuPadding: EdgeInsets.all(0),
      // clipBehavior: Clip.hardEdge,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(Constants.borderRadius),
      // ),
      position: RelativeRect.fromLTRB(
        position?.right ?? 0,
        position?.top ?? 0,
        position?.right ?? MediaQuery.of(context).size.width,
        position?.bottom ?? MediaQuery.of(context).size.height,
      ),
    );
  }
}
