import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/ui/screens/device_screen.dart';
import 'package:wiimote_dsu/ui/screens/settings_screen.dart';
import 'server/dsu_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final gyroSettings = GyroSettings.getSettings(prefs);
  final accSettings = AccSettings.getSettings(prefs);

  final server = DSUServer(gyroSettings, accSettings);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<GyroSettings>.value(value: gyroSettings),
    ChangeNotifierProvider<AccSettings>.value(value: accSettings),
    Provider<DSUServer>.value(
      value: server,
    ),
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
  MyHomePage({Key key, this.title, this.preferences}) : super(key: key);

  final String title;
  final SharedPreferences preferences;

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
      return SettingsScreen();
    }));
  }
}
