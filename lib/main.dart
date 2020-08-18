import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'server/dsu_server.dart';
import 'ui/button_rectangle.dart';
import 'ui/button_round.dart';
import 'ui/dpad_arrow.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DSUServer server;

  void buttonDown(btnName) {
    HapticFeedback.mediumImpact();
    server.slots[0].state[server.slots[0].keyMap[btnName]] = 0xFF;
  }

  void buttonUp(btnName) {
    server.slots[0].state[server.slots[0].keyMap[btnName]] = 0x00;
  }

  _MyHomePageState() {
    server = new DSUServer(portNum: 26760);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DpadArrow(Icons.arrow_upward, "D_UP", true, buttonDown, buttonUp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DpadArrow(
                    Icons.arrow_back, "D_LEFT", false, buttonDown, buttonUp),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                ),
                DpadArrow(Icons.arrow_forward, "D_RIGHT", false, buttonDown,
                    buttonUp),
              ],
            ),
            DpadArrow(
                Icons.arrow_downward, "D_DOWN", true, buttonDown, buttonUp),
            SizedBox(
              height: 50.0,
            ),
            PadRoundButton(null, "A", 65.0, 65.0, buttonDown, buttonUp),
            SizedBox(
              height: 15.0,
            ),
            PadRectangleButton(null, "B", 65.0, 85.0, buttonDown, buttonUp),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PadRoundButton(
                    Icons.remove, "MINUS", 30.0, 30.0, buttonDown, buttonUp),
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
    );
  }
}
