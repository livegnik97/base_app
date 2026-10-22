import 'dart:math';

import 'package:flutter/material.dart';
import 'package:base_app/presentation/widgets/buttons/custom_text_button.dart';

class ExpandableFabController extends ChangeNotifier {
  bool _open = false;

  ExpandableFabController({bool initialOpen = false}) {
    _open = initialOpen;
  }

  bool get isOpen => _open;
  bool get isClosed => !_open;

  void toggle() {
    _changeState(!_open);
  }

  void close() {
    _changeState(false);
  }

  void open() {
    _changeState(true);
  }

  void _changeState(bool open) {
    try {
      _open = open;
      notifyListeners();
    } catch (_) {}
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.controller,
    this.distance = 70,
    required this.children,
  });

  final ExpandableFabController? controller;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  late final ExpandableFabController expandableFabController;
  late bool _currentOpenState;

  @override
  void initState() {
    super.initState();
    expandableFabController = widget.controller ?? ExpandableFabController();

    expandableFabController.addListener(
      () {
        try {
          final open = expandableFabController.isOpen;
          if (open != _currentOpenState) {
            _currentOpenState = open;
            setState(() {
              if (_currentOpenState) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          }
        } catch (_) {}
      },
    );

    _currentOpenState = expandableFabController.isOpen;

    _controller = AnimationController(
      value: _currentOpenState ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.controller == null) {
      expandableFabController.dispose();
    }
    super.dispose();
  }

  void _toggle() {
    expandableFabController.toggle();
    // setState(() {
    //   _open = !_open;
    //   if (_open) {
    //     _controller.forward();
    //   } else {
    //     _controller.reverse();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.hardEdge,
        children: [
          if (_currentOpenState)
            Positioned.fill(
              child: GestureDetector(
                onTapDown: (_) {
                  if (_currentOpenState) _toggle();
                },
                child: ColoredBox(color: Colors.transparent),
              ),
            ),
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    // final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 90.0; i < count; i++, angleInDegrees) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance + (70 * i),
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToCloseFab() {
    return !_currentOpenState
        ? const SizedBox()
        : FloatingActionButton(
            heroTag: '3',
            shape: CircleBorder(),
            onPressed: _toggle,
            child: Icon(
              Icons.close,
            ),
          );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _currentOpenState,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _currentOpenState ? 0.7 : 1.0,
          _currentOpenState ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _currentOpenState ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            heroTag: '4',
            shape: CircleBorder(),
            onPressed: _toggle,
            child: Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child:
              // Transform.rotate(
              // angle: (1.0 - progress.value) * pi / 2,
              // child:
              child!,
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
