import 'package:url_launcher/url_launcher.dart';

class CalendarHelper {
  CalendarHelper._();

  /// Abre Google Calendar con el evento prellenado (app si está instalada,
  /// navegador como respaldo). No requiere permiso de calendario.
  /// Devuelve false si no se pudo lanzar.
  static Future<bool> addEvent({
    required String title,
    required DateTime start,
    Duration duration = const Duration(hours: 1),
    String? description,
    String? location,
    Duration? reminder,
  }) async {
    try {
      final startUtc = start.toUtc();
      final endUtc = startUtc.add(duration);
      final params = <String, String>{
        'action': 'TEMPLATE',
        'text': title,
        'dates': '${_formatDate(startUtc)}/${_formatDate(endUtc)}',
        if (description != null && description.isNotEmpty)
          'details': description,
        if (location != null && location.isNotEmpty) 'location': location,
        if (reminder != null) 'trp': _formatDuration(reminder),
      };
      final uri = Uri.https('calendar.google.com', '/calendar/render', params);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    return false;
  }

  static String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}'
        '${two(date.month)}${two(date.day)}'
        'T${two(date.hour)}${two(date.minute)}${two(date.second)}Z';
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0 && minutes > 0) return 'PT${hours}H${minutes}M';
    if (hours > 0) return 'PT${hours}H';
    return 'PT${minutes}M';
  }
}
