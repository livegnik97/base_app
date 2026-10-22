import 'package:flutter/material.dart';

String formatAmPm(int hour24, int minute) {
  final safeHour = hour24 % 24;
  final safeMinute = minute.clamp(0, 59);
  final period = safeHour < 12 ? 'am' : 'pm';
  final hour12 = safeHour % 12 == 0 ? 12 : safeHour % 12;
  return '$hour12:${safeMinute.toString().padLeft(2, '0')} $period';
}

String? parseAmPmToHHMM(String text) {
  final compact = text
      .trim()
      .toLowerCase()
      .replaceAll('.', '')
      .replaceAll(' ', '');
  if (compact.isEmpty) return null;
  final match = RegExp(r'^(\d{1,2}):(\d{2})(am|pm)?$').firstMatch(compact);
  if (match == null) return null;
  final rawHour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  if (minute > 59) return null;
  final period = match.group(3);
  final int? hour24;
  if (period == null) {
    hour24 = rawHour <= 23 ? rawHour : null;
  } else if (period == 'am') {
    hour24 = rawHour == 12 ? 0 : (rawHour <= 12 ? rawHour : null);
  } else {
    hour24 = rawHour == 12 ? 12 : (rawHour <= 11 ? rawHour + 12 : null);
  }
  if (hour24 == null) return null;
  return '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

extension AmPmStringTime on String {
  String get toAmPm {
    final parts = split(':');
    if (parts.length < 2) return this;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null || hour > 23 || minute > 59) return this;
    return formatAmPm(hour, minute);
  }
}

extension AmPmTimeOfDay on TimeOfDay {
  String get toAmPm => formatAmPm(hour, minute);
}
