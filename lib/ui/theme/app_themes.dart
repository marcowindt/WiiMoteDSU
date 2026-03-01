import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/theme/wii_controller_theme.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    extensions: [WiiControllerThemeData(theme: WiiControllerTheme.light())],
  );

  static ThemeData get darkTheme => blackWiiTheme;

  static ThemeData get blackWiiTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFF5AC8FA),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF5AC8FA),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFE5E5E7),
      onPrimary: const Color(0xFF252526),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Color(0xFFE5E5E7),
    ),
    extensions: [WiiControllerThemeData(theme: WiiControllerTheme.blackWii())],
  );
}
