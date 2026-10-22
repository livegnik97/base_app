import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart' as date_symbol_data;
import 'package:intl/intl.dart' as intl;

class AmPmMaterialLocalizationEs extends MaterialLocalizationEs {
  const AmPmMaterialLocalizationEs({
    super.localeName = 'es',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get anteMeridiemAbbreviation => 'am';

  @override
  String get postMeridiemAbbreviation => 'pm';
}

class AmPmMaterialLocalizationEn extends MaterialLocalizationEn {
  const AmPmMaterialLocalizationEn({
    super.localeName = 'en',
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get anteMeridiemAbbreviation => 'am';

  @override
  String get postMeridiemAbbreviation => 'pm';
}

class AmPmMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const AmPmMaterialLocalizationsDelegate();

  static bool _dateDataLoaded = false;

  @override
  bool isSupported(Locale locale) =>
      GlobalMaterialLocalizations.delegate.isSupported(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    if (!_dateDataLoaded) {
      await date_symbol_data.initializeDateFormatting();
      _dateDataLoaded = true;
    }

    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    intl.DateFormat fullYearFormat;
    intl.DateFormat compactDateFormat;
    intl.DateFormat shortDateFormat;
    intl.DateFormat mediumDateFormat;
    intl.DateFormat longDateFormat;
    intl.DateFormat yearMonthFormat;
    intl.DateFormat shortMonthDayFormat;
    if (intl.DateFormat.localeExists(localeName)) {
      fullYearFormat = intl.DateFormat.y(localeName);
      compactDateFormat = intl.DateFormat.yMd(localeName);
      shortDateFormat = intl.DateFormat.yMMMd(localeName);
      mediumDateFormat = intl.DateFormat.MMMEd(localeName);
      longDateFormat = intl.DateFormat.yMMMMEEEEd(localeName);
      yearMonthFormat = intl.DateFormat.yMMMM(localeName);
      shortMonthDayFormat = intl.DateFormat.MMMd(localeName);
    } else if (intl.DateFormat.localeExists(locale.languageCode)) {
      fullYearFormat = intl.DateFormat.y(locale.languageCode);
      compactDateFormat = intl.DateFormat.yMd(locale.languageCode);
      shortDateFormat = intl.DateFormat.yMMMd(locale.languageCode);
      mediumDateFormat = intl.DateFormat.MMMEd(locale.languageCode);
      longDateFormat = intl.DateFormat.yMMMMEEEEd(locale.languageCode);
      yearMonthFormat = intl.DateFormat.yMMMM(locale.languageCode);
      shortMonthDayFormat = intl.DateFormat.MMMd(locale.languageCode);
    } else {
      fullYearFormat = intl.DateFormat.y();
      compactDateFormat = intl.DateFormat.yMd();
      shortDateFormat = intl.DateFormat.yMMMd();
      mediumDateFormat = intl.DateFormat.MMMEd();
      longDateFormat = intl.DateFormat.yMMMMEEEEd();
      yearMonthFormat = intl.DateFormat.yMMMM();
      shortMonthDayFormat = intl.DateFormat.MMMd();
    }

    intl.NumberFormat decimalFormat;
    intl.NumberFormat twoDigitZeroPaddedFormat;
    if (intl.NumberFormat.localeExists(localeName)) {
      decimalFormat = intl.NumberFormat.decimalPattern(localeName);
      twoDigitZeroPaddedFormat = intl.NumberFormat('00', localeName);
    } else if (intl.NumberFormat.localeExists(locale.languageCode)) {
      decimalFormat = intl.NumberFormat.decimalPattern(locale.languageCode);
      twoDigitZeroPaddedFormat = intl.NumberFormat('00', locale.languageCode);
    } else {
      decimalFormat = intl.NumberFormat.decimalPattern();
      twoDigitZeroPaddedFormat = intl.NumberFormat('00');
    }

    final base = getMaterialTranslation(
      locale,
      fullYearFormat,
      compactDateFormat,
      shortDateFormat,
      mediumDateFormat,
      longDateFormat,
      yearMonthFormat,
      shortMonthDayFormat,
      decimalFormat,
      twoDigitZeroPaddedFormat,
    );

    if (base is MaterialLocalizationEs) {
      return AmPmMaterialLocalizationEs(
        localeName: localeName,
        fullYearFormat: fullYearFormat,
        compactDateFormat: compactDateFormat,
        shortDateFormat: shortDateFormat,
        mediumDateFormat: mediumDateFormat,
        longDateFormat: longDateFormat,
        yearMonthFormat: yearMonthFormat,
        shortMonthDayFormat: shortMonthDayFormat,
        decimalFormat: decimalFormat,
        twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
      );
    }
    if (base is MaterialLocalizationEn) {
      return AmPmMaterialLocalizationEn(
        localeName: localeName,
        fullYearFormat: fullYearFormat,
        compactDateFormat: compactDateFormat,
        shortDateFormat: shortDateFormat,
        mediumDateFormat: mediumDateFormat,
        longDateFormat: longDateFormat,
        yearMonthFormat: yearMonthFormat,
        shortMonthDayFormat: shortMonthDayFormat,
        decimalFormat: decimalFormat,
        twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
      );
    }
    return base!;
  }

  @override
  bool shouldReload(AmPmMaterialLocalizationsDelegate old) => false;
}
