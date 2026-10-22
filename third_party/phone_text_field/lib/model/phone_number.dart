import 'dart:ui';

import '../helper/countries.dart';

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;
  int? minLength;
  int? maxLength;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    this.minLength,
    this.maxLength,
  });

  factory PhoneNumber.fromCompleteNumber({
    required String completeNumber,
    Locale locale = const Locale('en', ''),
  }) {
    if (completeNumber == '') {
      return PhoneNumber(
        countryISOCode: '',
        countryCode: '',
        number: '',
      );
    }

    try {
      final country = getCountry(completeNumber, locale);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber
            .substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber
            .substring(country.dialCode.length + country.regionCode.length);
      }
      return PhoneNumber(
        countryISOCode: country.code,
        countryCode: country.dialCode + country.regionCode,
        number: number,
        minLength: country.minLength,
        maxLength: country.maxLength,
      );
    }
    //  on InvalidCharactersException {
    //   rethrow;
    // }
    on Exception {
      return PhoneNumber(
        countryISOCode: '',
        countryCode: '',
        number: '',
      );
    }
  }

  bool isValidNumber({bool isRequired = true}) {
    try {
      if (!isRequired && number.isEmpty) return true;
      final country = getCountry(completeNumber);
      if (number.length < country.minLength) {
        return false;
      }

      if (number.length > country.maxLength) {
        return false;
      }
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return false;
    }
  }

  String get completeNumber {
    var cn = countryCode + number;
    if (!cn.startsWith('+')) {
      cn = '+$cn';
    }
    return cn;
  }

  static Country getCountry(String phoneNumber,
      [Locale locale = const Locale('en', '')]) {
    if (phoneNumber == '') {
      throw NumberTooShortException();
    }

    final validPhoneNumber = RegExp(r'^[+0-9]*[0-9]*$');

    if (!validPhoneNumber.hasMatch(phoneNumber)) {
      throw InvalidCharactersException();
    }

    CountriesHelper.init(locale.languageCode.toLowerCase());

    if (phoneNumber.startsWith('+')) {
      return countries.firstWhere(
        (country) => phoneNumber
            .substring(1)
            .startsWith(country.dialCode + country.regionCode),
      );
    }
    return countries.firstWhere(
      (country) =>
          phoneNumber.startsWith(country.dialCode + country.regionCode),
    );
  }

  @override
  String toString() =>
      'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number, minLength: $minLength, maxLength: $maxLength)';
}
