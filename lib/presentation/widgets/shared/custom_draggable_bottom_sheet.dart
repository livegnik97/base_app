import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/core/constants/constants.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';
import 'package:base_app/presentation/widgets/shared/custom_bottom_sheet_handle.dart';

class CustomDraggableBottomSheet extends StatefulWidget {
  const CustomDraggableBottomSheet({
    super.key,
    this.initialChildSize = 0.5,
    this.appBar,
    required this.slivers,
    this.bootomBar,
    this.backgrondColor,
    this.maxChildSize = .93,
    this.onScroll,
    this.onDraggableScroll,
    this.showDraggableWidget = true,
  });

  final double initialChildSize;
  final PinnedHeaderDelegate? appBar;
  final List<Widget> slivers;
  final Widget? bootomBar;
  final Color? backgrondColor;
  final double maxChildSize;
  final bool showDraggableWidget;
  final void Function(ScrollController scrollController)? onScroll;
  final void Function(
    DraggableScrollableController draggableScrollableController,
  )?
  onDraggableScroll;

  @override
  State<CustomDraggableBottomSheet> createState() =>
      _CustomDraggableBottomSheetState();
}

class _CustomDraggableBottomSheetState
    extends State<CustomDraggableBottomSheet> {
  bool isInit = false;
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    if (widget.onDraggableScroll != null) {
      draggableScrollableController.addListener(
        () => widget.onDraggableScroll?.call(draggableScrollableController),
      );
    }
  }

  @override
  dispose() {
    draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: DraggableScrollableSheet(
            initialChildSize: widget.initialChildSize,
            controller: draggableScrollableController,
            maxChildSize: widget.maxChildSize,
            builder: (context, scrollController) {
              if (!isInit && widget.onScroll != null) {
                isInit = true;
                scrollController.addListener(
                  () => widget.onScroll!(scrollController),
                );
              }
              return CustomContainer(
                color: widget.backgrondColor ?? context.surfaceContainerLow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Constants.borderRadius),
                  topRight: Radius.circular(Constants.borderRadius),
                ),
                child: Column(
                  children: [
                    if (widget.showDraggableWidget)
                      CustomBottomSheetHandle(
                        backgroundColor: widget.appBar?.backgroundColor,
                      ),
                    Expanded(
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          if (widget.appBar != null)
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: widget.appBar!,
                            ),

                          ...widget.slivers,
                        ],
                      ),
                    ),
                    ?widget.bootomBar,
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final Color? backgroundColor;

  PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.backgroundColor,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: CustomContainer(
        color: backgroundColor ?? context.surfaceContainerLow,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [],
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(Constants.borderRadius),
        //   topRight: Radius.circular(Constants.borderRadius),
        // ),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
