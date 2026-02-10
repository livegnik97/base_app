import 'package:vibration/vibration.dart';

class VibrationManager {
  static void vibrate() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      final hasAmplitudeControl = await Vibration.hasAmplitudeControl();
      final hasCustomVibrationsSupport =
          await Vibration.hasCustomVibrationsSupport();
      if (hasVibrator) {
        Vibration.vibrate(
          amplitude: hasAmplitudeControl ? 80 : -1,
          duration: hasCustomVibrationsSupport ? 100 : 500,
        );
      }
    } catch (_) {}
  }
}
