import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/constants/hero_tags.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_app/presentation/widgets/shared/custom_linear_loading_widget.dart';
import 'package:base_app/presentation/widgets/shared/theme_change.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppbar(
  BuildContext context, {
  Key? key,
  bool disableHero = false,
  bool animateTitleWhenChangeValue = false,
  String? subtitle,

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
  bool isLoading = false,
}) {
  Widget? titleReal = titleWidget;
  if (title != null && titleWidget == null) {
    titleReal = Row(
      key: animateTitleWhenChangeValue ? Key('$title-appbar-title') : null,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AutoSizeText(
            title,
            style: context.titleLarge,
            maxLines: 1,
            minFontSize: 1,
          ),
        ),
      ],
    );
    if (animateTitleWhenChangeValue) {
      titleReal = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: titleReal,
      );
    }
    if (subtitle != null) {
      final subtitleWidget = Row(
        key: animateTitleWhenChangeValue
            ? Key('$subtitle-appbar-subtitle')
            : null,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AutoSizeText(
              subtitle,
              style: context.titleSmall,
              maxLines: 1,
              minFontSize: 1,
            ),
          ),
        ],
      );
      titleReal = FittedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleReal,
            if (animateTitleWhenChangeValue)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: subtitleWidget,
              ),
            if (!animateTitleWhenChangeValue) subtitleWidget,
          ],
        ),
      );
    }
  }
  if (!disableHero) {
    titleReal = Hero(
      tag: HeroTags.appbarTitle,
      child: Material(color: Colors.transparent, child: titleReal),
    );
  }
  List<Widget>? realActions = actions;
  if (Constants.isDev && Constants.showThemeChangeInCustomAppBar) {
    realActions ??= [];
    realActions.insert(
      0,
      ThemeChangeWidget(),
    );
  }
  return AppBar(
    key: key,
    title: titleReal,
    //* default
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: realActions,
    automaticallyImplyActions: automaticallyImplyActions,
    flexibleSpace: flexibleSpace,
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
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(
        4 + (bottom?.preferredSize.height ?? 0),
      ),
      child: Column(
        children: <Widget>[
          CustomLinearLoadingWidget(isLoading: isLoading, height: 4),
          ?bottom,
        ],
      ),
    ),
  );
}
