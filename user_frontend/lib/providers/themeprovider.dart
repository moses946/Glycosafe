import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  // Constructor
  ThemeNotifier() : _themeMode = _initializeThemeMode();

  // Static method to initialize _themeMode based on the system's theme
  static ThemeMode _initializeThemeMode() {
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.dark;
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
