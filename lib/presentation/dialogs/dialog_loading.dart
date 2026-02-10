import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/l10n/app_localizations.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/shared/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogLoadingController extends ChangeNotifier {
  double? _progress;
  double? get progress => _progress;

  bool _showActionCancel = false;
  bool get showActionCancel => _showActionCancel;

  void updateProgress(double? progress) {
    try {
      _progress = progress;
      if (_progress != null) {
        if (_progress! > 1) {
          _progress = 1;
        }
        if (_progress! < 0) {
          _progress = 0;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  void showCancelButton() {
    try {
      _showActionCancel = true;
      notifyListeners();
    } catch (_) {}
  }

  void hideCancelButton() {
    try {
      _showActionCancel = false;
      notifyListeners();
    } catch (_) {}
  }
}

class DialogLoading extends StatefulWidget {
  final String? textInfo;
  final double? width;
  final double? height;
  final Color? color;
  final bool boxShadow;
  final int? waitTimeInSeconds;
  final DialogLoadingController? dialogProgressController;

  const DialogLoading({
    super.key,
    this.textInfo,
    this.width,
    this.height,
    this.color,
    this.boxShadow = true,
    this.waitTimeInSeconds,
    this.dialogProgressController,
  });

  @override
  State<DialogLoading> createState() => _DialogLoadingState();
}

class _DialogLoadingState extends State<DialogLoading> {
  bool showActionCancel = false;

  double? progress;

  @override
  void initState() {
    super.initState();
    if (widget.waitTimeInSeconds != null && widget.waitTimeInSeconds! >= 0) {
      if (widget.waitTimeInSeconds! == 0) {
        showActionCancel = true;
      } else {
        Future.delayed(Duration(seconds: widget.waitTimeInSeconds!), () {
          showActionCancel = true;
          widget.dialogProgressController?.showCancelButton();
          setState(() {});
        });
      }
    }
    widget.dialogProgressController?.addListener(progressListener);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    widget.dialogProgressController?.removeListener(progressListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 35.0,
          width: 35.0,
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: progress != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AutoSizeText(
                              "${progress!.toStringAsFixed(2)}%",
                              style: context.bodySmall.copyWith(fontSize: 8),
                              maxLines: 1,
                              minFontSize: 1,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: progress != null
                      ? CircularProgressIndicator(value: progress)
                      : CustomLoadingWidget(color: widget.color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AutoSizeText(
          widget.textInfo ?? AppLocalizations.of(context)!.processing,
          style: context.bodyMedium,
          maxLines: 1,
          minFontSize: 1,
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomFilledButton(
              label: AppLocalizations.of(context)!.cancel,
              color: widget.color,
              onPressed: () {
                context.pop();
              },
            ),
          ),
          crossFadeState: showActionCancel
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  void progressListener() {
    try {
      progress = widget.dialogProgressController?.progress;
      showActionCancel =
          widget.dialogProgressController?.showActionCancel ?? showActionCancel;
      setState(() {});
    } catch (_) {}
  }
}
