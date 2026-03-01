import 'package:flutter/material.dart';

class WiiControllerTheme {
  final Color controllerBackground;
  final Color buttonColor;
  final Color buttonPressedColor;
  final Color buttonForeground;
  final Color dpadBackground;
  final Color dpadArrowDefault;
  final Color dpadArrowPressed;
  final Color dpadArrowIconDefault;
  final Color dpadArrowIconPressed;
  final Color thumbstickBackground;
  final Color thumbstickStick;

  const WiiControllerTheme({
    required this.controllerBackground,
    required this.buttonColor,
    required this.buttonPressedColor,
    required this.buttonForeground,
    required this.dpadBackground,
    required this.dpadArrowDefault,
    required this.dpadArrowPressed,
    required this.dpadArrowIconDefault,
    required this.dpadArrowIconPressed,
    required this.thumbstickBackground,
    required this.thumbstickStick,
  });

  factory WiiControllerTheme.light() => WiiControllerTheme(
    controllerBackground: Colors.white,
    buttonColor: Colors.white70,
    buttonPressedColor: Colors.black26,
    buttonForeground: Colors.black87,
    dpadBackground: Colors.grey.shade100,
    dpadArrowDefault: Colors.white,
    dpadArrowPressed: Colors.black26,
    dpadArrowIconDefault: Colors.blueGrey,
    dpadArrowIconPressed: Colors.blue,
    thumbstickBackground: Colors.grey.shade100,
    thumbstickStick: Colors.black12,
  );

  factory WiiControllerTheme.blackWii() => WiiControllerTheme(
    controllerBackground: const Color(0xFF121212),
    buttonColor: const Color(0xFF333333),
    buttonPressedColor: const Color(0xFF5A5A5E),
    buttonForeground: const Color(0xFFE5E5E7),
    dpadBackground: const Color(0xFF212121),
    dpadArrowDefault: const Color(0xFF333333),
    dpadArrowPressed: const Color(0xFF5A5A5E),
    dpadArrowIconDefault: const Color(0xFFFFFFFF),
    dpadArrowIconPressed: const Color(0xFF5AC8FA),
    thumbstickBackground: const Color(0xFF3A3A3C),
    thumbstickStick: const Color(0xFF5A5A5E),
  );
}

extension WiiControllerThemeExtension on BuildContext {
  WiiControllerTheme get wiiControllerTheme {
    return Theme.of(this).extension<WiiControllerThemeData>()?.theme ??
        WiiControllerTheme.light();
  }
}

class WiiControllerThemeData extends ThemeExtension<WiiControllerThemeData> {
  final WiiControllerTheme theme;

  const WiiControllerThemeData({required this.theme});

  @override
  WiiControllerThemeData copyWith({WiiControllerTheme? theme}) {
    return WiiControllerThemeData(theme: theme ?? this.theme);
  }

  @override
  WiiControllerThemeData lerp(
    ThemeExtension<WiiControllerThemeData>? other,
    double t,
  ) {
    if (other is! WiiControllerThemeData) return this;
    return WiiControllerThemeData(theme: other.theme);
  }
}
