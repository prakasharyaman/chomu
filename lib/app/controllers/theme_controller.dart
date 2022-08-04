// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController themeController = Get.find();
  var theme = "system".obs;
  final store = GetStorage();
  late ThemeMode _themeMode;
  @override
  void onInit() {
    super.onInit();
    _themeMode = ThemeMode.system;
    var storageTheme = store.read("theme");
    if (storageTheme == null) {
      theme.value = "system";
    }
    if (theme.value == "system") {
      _themeMode = ThemeMode.system;
    } else if (theme.value == "light") {
      _themeMode = ThemeMode.light;
    } else if (theme.value == "dark") {
      _themeMode = ThemeMode.dark;
    }
    Get.changeThemeMode(_themeMode);
  }

  ThemeMode get themeMode => _themeMode;
  String get currentTheme => theme.value;

  Future<void> setThemeMode(String value) async {
    theme.value = value;
    _themeMode = getThemeModeFromString(value);
    Get.changeThemeMode(_themeMode);
    await store.write('theme', value);
    Get.snackbar(
      'Theme Changed',
      'Please refresh the home page to see the changes',
      snackPosition: SnackPosition.BOTTOM,
    );
    update();
  }

  ThemeMode getThemeModeFromString(String themeString) {
    ThemeMode setThemeMode = ThemeMode.system;
    if (themeString == 'light') {
      setThemeMode = ThemeMode.light;
    }
    if (themeString == 'dark') {
      setThemeMode = ThemeMode.dark;
    }
    return setThemeMode;
  }

  getThemeModeFromStore() async {
    String themeString = store.read('theme') ?? 'system';
    setThemeMode(themeString);
  }

  // checks whether darkmode is set via system or previously by user
  bool get isDarkModeOn {
    if (currentTheme == 'system') {
      if (WidgetsBinding.instance.window.platformBrightness ==
          Brightness.dark) {
        return true;
      }
    }
    if (currentTheme == 'dark') {
      return true;
    }
    return false;
  }
}
