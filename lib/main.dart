import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/server/server_isolate.dart';
import 'package:wiimote_dsu/ui/screens/device_screen.dart';
import 'package:wiimote_dsu/ui/screens/settings_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();

  final gyroSettings = GyroSettings.getSettings(prefs);
  final accSettings = AccSettings.getSettings(prefs);
  final deviceSettings = DeviceSettings.getSettings(prefs);

  final mainToIsolateStream = await ServerIsolate.init();

  final dsuDevice =
      Device(gyroSettings, accSettings, deviceSettings, mainToIsolateStream);
  mainToIsolateStream.send(dsuDevice);
  dsuDevice.start();

  WakelockPlus.enable();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<GyroSettings>.value(value: gyroSettings),
    ChangeNotifierProvider<AccSettings>.value(value: accSettings),
    ChangeNotifierProvider<DeviceSettings>.value(value: deviceSettings),
    Provider<SendPort>.value(value: mainToIsolateStream),
  ], child: WiiMoteDSUApp(prefs)));
}

class WiiMoteDSUApp extends StatelessWidget {
  final SharedPreferences preferences;

  WiiMoteDSUApp(this.preferences);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WiiMoteDSU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'WiiMoteDSU',
        preferences: preferences,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.preferences}) : super(key: key);

  final String? title;
  final SharedPreferences? preferences;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: <Widget>[
            DeviceScreen(),
            Positioned(
                top: 30.0,
                left: 2.0,
                child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => _openSettings(context))),
            Positioned(
              top: 30.0,
              right: 2.0,
              child: Consumer<DeviceSettings>(
                builder: (context, settings, child) {
                  return IconButton(
                    icon: Text(
                      "${settings.slot}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    onPressed: null,
                  );
                },
              ),
            )
          ]),
        ));
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SettingsScreen();
    }));
  }
}
