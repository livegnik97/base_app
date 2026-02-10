import 'package:base_app/data/shared_preferences/my_shared.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, int>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<int> {
  ThemeNotifier() : super(1) {
    init();
  }

  Future<void> init() async {
    final themeIndex = await MyShared.getInt(
      MySharedConstants.themeModeSelect,
      1,
    );
    state = themeIndex;
  }

  void changeTheme(int themeIndex) {
    if (themeIndex == state) return;
    MyShared.setValue<int>(MySharedConstants.themeModeSelect, themeIndex);
    state = themeIndex;
  }
}
