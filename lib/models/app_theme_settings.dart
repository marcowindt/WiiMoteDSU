import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kUseBlackWiiThemeKey = 'use_black_wii_theme';

class AppThemeSettings extends ChangeNotifier {
  final SharedPreferences preferences;
  bool useBlackWiiTheme;

  AppThemeSettings(this.preferences, this.useBlackWiiTheme);

  void setUseBlackWiiTheme(bool value) {
    useBlackWiiTheme = value;
    preferences.setBool(_kUseBlackWiiThemeKey, value);
    notifyListeners();
  }

  /// Theme follows device light/dark; when [useBlackWiiTheme] is true we use dark.
  ThemeMode get themeMode =>
      useBlackWiiTheme ? ThemeMode.dark : ThemeMode.system;

  factory AppThemeSettings.getSettings(SharedPreferences preferences) {
    final useBlackWii = preferences.getBool(_kUseBlackWiiThemeKey) ?? false;
    return AppThemeSettings(preferences, useBlackWii);
  }
}
