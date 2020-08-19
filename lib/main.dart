import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/ui/screens/settings_screen.dart';
import 'server/dsu_server.dart';
import 'ui/button_rectangle.dart';
import 'ui/button_round.dart';
import 'ui/dpad_arrow.dart';
import 'package:get_ip/get_ip.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    SharedPreferences.getInstance().then((prefs) {
      runApp(MyApp(prefs));
    });
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  MyApp(this.preferences);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WiiMoteDSU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        // appBarTheme: AppBarTheme(brightness: Theme.of(context).brightness),
      ),
      home: MyHomePage(
        title: 'WiiMoteDSU',
        preferences: preferences,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.preferences}) : super(key: key);

  final String title;
  final SharedPreferences preferences;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DSUServer server;
  GyroSettings gyroSettings;
  AccSettings accSettings;

  @override
  void initState() {
    gyroSettings = GyroSettings(
      widget.preferences,
      GyroSettings.getBool(widget.preferences, 'adjust_gyro_orientation'),
      GyroSettings.getBool(widget.preferences, 'invert_gyro_x'),
      GyroSettings.getBool(widget.preferences, 'invert_gyro_y'),
      GyroSettings.getBool(widget.preferences, 'invert_gyro_z'),
      GyroSettings.getDouble(widget.preferences, 'gyro_sensitivity'),
    );
    accSettings = AccSettings(
      widget.preferences,
      AccSettings.getBool(widget.preferences, 'acc_enabled'),
      AccSettings.getBool(widget.preferences, 'adjust_acc_orientation'),
      AccSettings.getBool(widget.preferences, 'invert_acc_x'),
      AccSettings.getBool(widget.preferences, 'invert_acc_y'),
      AccSettings.getBool(widget.preferences, 'invert_acc_z'),
      AccSettings.getDouble(widget.preferences, 'acc_sensitivity'),
    );
    server = new DSUServer(gyroSettings, accSettings, portNum: 26760);
    super.initState();
  }

  void buttonDown(btnName) {
    HapticFeedback.mediumImpact();
    server.slots[0].state[server.slots[0].keyMap[btnName]] = 0xFF;
  }

  void buttonUp(btnName) {
    server.slots[0].state[server.slots[0].keyMap[btnName]] = 0x00;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: gyroSettings),
          ChangeNotifierProvider.value(value: accSettings),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DpadArrow(
                      Icons.arrow_upward, "D_UP", true, buttonDown, buttonUp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DpadArrow(Icons.arrow_back, "D_LEFT", false, buttonDown,
                          buttonUp),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 25.0),
                      ),
                      DpadArrow(Icons.arrow_forward, "D_RIGHT", false,
                          buttonDown, buttonUp),
                    ],
                  ),
                  DpadArrow(Icons.arrow_downward, "D_DOWN", true, buttonDown,
                      buttonUp),
                  SizedBox(
                    height: 50.0,
                  ),
                  PadRoundButton(null, "A", 65.0, 65.0, buttonDown, buttonUp),
                  SizedBox(
                    height: 15.0,
                  ),
                  PadRectangleButton(
                      null, "B", 65.0, 85.0, buttonDown, buttonUp),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PadRoundButton(Icons.remove, "MINUS", 30.0, 30.0,
                          buttonDown, buttonUp),
                      PadRoundButton(
                          Icons.home, "HOME", 30.0, 30.0, buttonDown, buttonUp),
                      PadRoundButton(
                          Icons.add, "PLUS", 30.0, 30.0, buttonDown, buttonUp),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  PadRoundButton(null, "1", 45.0, 45.0, buttonDown, buttonUp),
                  SizedBox(
                    height: 15.0,
                  ),
                  PadRoundButton(null, "2", 45.0, 45.0, buttonDown, buttonUp),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 2.0),
                child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => _openSettings(context))),
          ]),
        ));
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return MultiProvider(providers: [
        ChangeNotifierProvider.value(value: gyroSettings),
        ChangeNotifierProvider.value(value: accSettings),
      ], child: SettingsScreen());
    }));
  }
}
