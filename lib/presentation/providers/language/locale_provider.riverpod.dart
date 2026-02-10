import 'dart:ui';

import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter_riverpod/legacy.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, LocaleState>((
  ref,
) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier() : super(LocaleState()) {
    init();
  }

  Future<void> init() async {
    final locale = await MyShared.getString(
      MySharedConstants.languageSelect,
      L10n.all[0].languageCode,
    );
    state = state.copyWith(locale: Locale(locale));
  }

  Future<bool> alreadySelectedLanguage() async {
    final locale = await MyShared.getStringOrNull(
      MySharedConstants.languageSelect,
    );
    return locale != null;
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    MyShared.setValue<String>(
      MySharedConstants.languageSelect,
      locale.languageCode,
    );
    state = state.copyWith(locale: locale);
  }
}

class LocaleState {
  final Locale locale;

  LocaleState({this.locale = const Locale("es")});

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}
