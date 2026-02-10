import 'package:flutter/material.dart';

class CountDownWidget extends StatelessWidget {
  const CountDownWidget({
    super.key,
    this.seconds = 90,
    required this.timeOut,
    this.style,
  });

  final int seconds;
  final VoidCallback timeOut;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return _CronoWidget(start: seconds, timeOut: timeOut, style: style);
  }
}

class _CronoWidget extends StatefulWidget {
  const _CronoWidget({required this.start, this.timeOut, this.style});
  final int start;
  final Function? timeOut;
  final TextStyle? style;

  @override
  State<_CronoWidget> createState() => _CronoWidgetState();
}

class _CronoWidgetState extends State<_CronoWidget>
    with TickerProviderStateMixin {
  int counter = 0;
  AnimationController? controller;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.start,
      ), // gameData.levelClock is a user entered number elsewhere in the applciation
    );
    if (widget.start > 0) {
      controller?.forward().whenComplete(() => widget.timeOut?.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start == 0) {
      if (controller!.isAnimating) {
        controller!.stop();
      }
    }
    return _CountDownText(
      style: widget.style,
      animation: StepTween(
        begin: widget.start, // THIS IS A USER ENTERED NUMBER
        end: 0,
      ).animate(controller!),
    );
  }
}

class _CountDownText extends AnimatedWidget {
  const _CountDownText({required this.animation, this.style})
    : super(listenable: animation);
  final Animation<int> animation;
  final TextStyle? style;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(timerText);
  }
}
