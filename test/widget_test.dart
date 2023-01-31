// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wiimote_dsu/main.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

void main() {
  testWidgets('Settings button available', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final gyroSettings = GyroSettings.getSettings(prefs);
    final accSettings = AccSettings.getSettings(prefs);
    final deviceSettings = DeviceSettings.getSettings(prefs);

    await tester.pumpWidget(MultiProvider(providers: [
      ChangeNotifierProvider<GyroSettings>.value(value: gyroSettings),
      ChangeNotifierProvider<AccSettings>.value(value: accSettings),
      ChangeNotifierProvider<DeviceSettings>.value(value: deviceSettings),
      Provider<SendPort>.value(
        value: ReceivePort().sendPort,
      ),
    ], child: WiiMoteDSUApp(prefs)));

    // Verify that the settings button appears on screen
    expect(find.widgetWithIcon(IconButton, Icons.settings), findsOneWidget,
        reason: "Settings button available");
  });
}
