import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:base_app/domain/repositories/remote/usecases/user_remote_repository.dart';
import 'package:base_app/l10n/l10n.dart';

import 'package:base_app/presentation/providers/data/api_provider.riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, LocaleState>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<LocaleState> {
  late final UserRemoteRepository _userApi;

  @override
  build() {
    _userApi = ref.read(apiProvider).user;
    Future.delayed(Duration.zero, () => init());
    return LocaleState();
  }

  Future<void> init() async {
    final locale = await MyShared.getString(
      MySharedConstants.languageSelect,
      L10n.all[0].languageCode,
    );
    _userApi.changeLanguage(locale);
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
    _userApi.changeLanguage(locale.languageCode);
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
