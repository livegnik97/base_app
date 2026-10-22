import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_app/data/shared_preferences/my_shared.dart';

final themeProvider = NotifierProvider<ThemeNotifier, int>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<int> {
  @override
  build() {
    Future.delayed(Duration.zero, () => init());
    return 0;
  }

  Future<void> init() async {
    final themeIndex = await MyShared.getInt(
      MySharedConstants.themeModeSelect,
      0,
    );
    state = themeIndex;
  }

  void changeTheme(int themeIndex) {
    if (themeIndex == state) return;
    MyShared.setValue<int>(MySharedConstants.themeModeSelect, themeIndex);
    state = themeIndex;
  }
}
