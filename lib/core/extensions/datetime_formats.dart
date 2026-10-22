// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base_app/core/extensions/am_pm_time.dart';

/// The following characters are available in explicit patterns:
///
///     Symbol   Meaning                Presentation       Example
///     ------   -------                ------------       -------
///     G        era designator         (Text)             AD
///     y        year                   (Number)           1996
///     M        month in year          (Text & Number)    July & 07
///     L        standalone month       (Text & Number)    July & 07
///     d        day in month           (Number)           10
///     c        standalone day         (Number)           10
///     h        hour in am/pm (1~12)   (Number)           12
///     H        hour in day (0~23)     (Number)           0
///     m        minute in hour         (Number)           30
///     s        second in minute       (Number)           55
///     S        fractional second      (Number)           978
///     E        day of week            (Text)             Tuesday
///     D        day in year            (Number)           189
///     a        am/pm marker           (Text)             PM
///     k        hour in day (1~24)     (Number)           24
///     K        hour in am/pm (0~11)   (Number)           0
///     Q        quarter                (Text)             Q3
///     '        escape for text        (Delimiter)        'Date='
///     ''       single quote           (Literal)          'o''clock'

extension DatetimeFormats on DateTime {
  //* formatos en reloj local: los DateTimes del backend llegan en UTC (...Z)
  String get toDDMMAAA {
    return DateFormat('dd/MM/yyyy').format(toLocal());
  }

  String get toHHMM {
    final local = toLocal();
    return formatAmPm(local.hour, local.minute);
  }

  String get toDDMMAAA_HHMM {
    return '$toDDMMAAA $toHHMM';
  }

  String get formatDate {
    final now = DateTime.now();
    final difference = now.difference(this);
    final local = toLocal();

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks semana${weeks > 1 ? 's' : ''}';
    } else {
      return '${local.day}/${local.month}/${local.year}';
    }
  }

  String get formatDateWithHour {
    return '$formatDate a las $toHHMM';
  }

  String get toDoW {
    const weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return weekdays[weekday - 1];
  }

  String get toMoY {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[month - 1];
  }

  String get toMoY_YY {
    return '$toMoY $year';
  }

  String get toDoW_DD_MoY {
    return '$toDoW, $day $toMoY';
  }

  String get toDoW_DD {
    return '$toDoW, $day';
  }

  String get toDoW_MM_YYYY {
    return '$toDoW_DD_MoY de $year';
  }

  String get toDoW_MM_YYYY_hhmma {
    return '$toDoW_DD_MoY de $year, $toHHMM';
  }

  TimeOfDay get toTimeOfDay {
    final local = toLocal();
    return TimeOfDay(hour: local.hour, minute: local.minute);
  }

  DateTime get firstDayOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get lastDayOfWeek {
    return add(Duration(days: 7 - weekday));
  }
}
