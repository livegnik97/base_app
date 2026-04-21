import 'package:base_app/core/extensions/color_extension.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/core/extensions/double_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScrollVerticalBackWidget extends StatefulWidget {
  const CustomScrollVerticalBackWidget({
    super.key,
    required this.child,
    this.backgroundWidget,
    this.backgroundColor,
    this.enableCloseButton = false,
  }) : assert(backgroundWidget == null || backgroundColor == null);

  final Widget child;
  final Widget? backgroundWidget;
  final Color? backgroundColor;
  final bool enableCloseButton;

  @override
  State<CustomScrollVerticalBackWidget> createState() =>
      _CustomScrollVerticalBackWidgetState();
}

class _CustomScrollVerticalBackWidgetState
    extends State<CustomScrollVerticalBackWidget> {
  final PageController pageController = PageController(initialPage: 1);
  bool isCloseProcess = false;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    pageController.addListener(_pageGlobalControllerListener);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: widget.backgroundWidget != null
            ? Colors.transparent
            : widget.backgroundColor != null
            ? widget.backgroundColor!.withOpacity2(opacity)
            : context.surfaceContainerLow.withOpacity2(opacity),
        child: Stack(
          children: [
            if (widget.backgroundWidget != null)
              Positioned.fill(
                child: Opacity(
                  opacity: opacity,
                  child: widget.backgroundWidget!,
                ),
              ),
            Positioned.fill(
              child: PageView(
                controller: pageController,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                onPageChanged: (value) {
                  try {
                    pageController.jumpToPage(1);
                  } catch (_) {}
                },
                children: [
                  Container(),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: (context.width * .1) * (1 - opacity),
                      // vertical: (context.height * .3) * (1 - state.opacity),
                    ),
                    child: widget.child,
                  ),
                  if (widget.enableCloseButton) Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pageGlobalControllerListener() {
    if (pageController.page == null) return;
    final diff = (1 - pageController.page!.toDouble()).abs().toSafePercent();
    if (diff > .35 && !isCloseProcess) {
      isCloseProcess = true;
      Future.delayed(Duration.zero, () {
        try {
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            context.pop();
          }
        } catch (_) {}
      });
    }
    setState(() {
      opacity = 1 - diff;
    });
  }
}
