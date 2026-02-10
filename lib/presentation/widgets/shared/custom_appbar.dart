import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/hero_tags.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppbar(
  BuildContext context, {
  Key? key,
  bool disableHero = false,

  Widget? leading,
  bool automaticallyImplyLeading = true,
  String? title,
  Widget? titleWidget,
  List<Widget>? actions,
  bool automaticallyImplyActions = true,
  Widget? flexibleSpace,
  PreferredSizeWidget? bottom,
  double? elevation,
  double? scrolledUnderElevation,
  ScrollNotificationPredicate notificationPredicate =
      defaultScrollNotificationPredicate,
  Color? shadowColor,
  Color? surfaceTintColor,
  ShapeBorder? shape,
  Color? backgroundColor,
  Color? foregroundColor,
  IconThemeData? iconTheme,
  IconThemeData? actionsIconTheme,
  bool primary = true,
  bool? centerTitle,
  bool excludeHeaderSemantics = false,
  double? titleSpacing,
  double toolbarOpacity = 1.0,
  double bottomOpacity = 1.0,
  double? toolbarHeight,
  double? leadingWidth,
  TextStyle? toolbarTextStyle,
  TextStyle? titleTextStyle,
  SystemUiOverlayStyle? systemOverlayStyle,
  bool forceMaterialTransparency = false,
  bool useDefaultSemanticsOrder = true,
  Clip? clipBehavior,
  EdgeInsetsGeometry? actionsPadding,
  bool animateColor = false,
}) {
  Widget? titleLabel;
  if (title != null && titleWidget == null) {
    titleLabel = Row(
      children: [
        Expanded(
          child: AutoSizeText(
            title,
            style: context.titleLarge,
            maxLines: 1,
            minFontSize: 1,
          ),
        ),
      ],
    );
    if (!disableHero) {
      titleLabel = Hero(
        tag: HeroTags.appbarTitle,
        child: Material(color: Colors.transparent, child: titleLabel),
      );
    }
  }
  return AppBar(
    key: key,
    title: titleWidget ?? titleLabel,
    //* default
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
    automaticallyImplyActions: automaticallyImplyActions,
    flexibleSpace: flexibleSpace,
    bottom: bottom,
    elevation: elevation,
    scrolledUnderElevation: scrolledUnderElevation,
    notificationPredicate: notificationPredicate,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    shape: shape,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    iconTheme: iconTheme,
    actionsIconTheme: actionsIconTheme,
    primary: primary,
    centerTitle: centerTitle,
    excludeHeaderSemantics: excludeHeaderSemantics,
    titleSpacing: titleSpacing,
    toolbarOpacity: toolbarOpacity,
    bottomOpacity: bottomOpacity,
    toolbarHeight: toolbarHeight,
    leadingWidth: leadingWidth,
    toolbarTextStyle: toolbarTextStyle,
    titleTextStyle: titleTextStyle,
    systemOverlayStyle: systemOverlayStyle,
    forceMaterialTransparency: forceMaterialTransparency,
    useDefaultSemanticsOrder: useDefaultSemanticsOrder,
    clipBehavior: clipBehavior,
    actionsPadding: actionsPadding,
    animateColor: animateColor,
  );
}
