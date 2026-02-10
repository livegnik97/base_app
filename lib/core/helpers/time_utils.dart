import 'package:intl/intl.dart';

class TimeUtils {
  static String timeLeft(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (hours > 0) {
      return '${hours.toString()} h ${minutes.toString().padLeft(2, '0')} min';
    }
    if (minutes > 0) {
      return '${minutes.toString()} min';
    }
    return '${seconds.toString().padLeft(2, '0')} seg';
  }

  static String formatHumanFull(DateTime date) {
    final f = DateFormat('dd/MM/yyy, hh:mm a');
    return f.format(date);
  }
}
