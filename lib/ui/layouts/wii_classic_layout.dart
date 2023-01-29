import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/ui/analog_thumbstick.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/l_zl_r_zr_buttons.dart';
import 'package:wiimote_dsu/ui/layouts/device_layout.dart';
import 'package:wiimote_dsu/ui/minus_home_plus_buttons.dart';
import 'package:wiimote_dsu/ui/x_y_a_b_buttons.dart';

class WiiClassicLayout extends StatefulWidget implements DeviceLayout {
  static const String name = "WiiClassic";

  @override
  State<StatefulWidget> createState() => _WiiClassicLayout();
}

class _WiiClassicLayout extends State<WiiClassicLayout> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LZLRZRButtons(),
      Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dpad(
            width: 120,
            height: 120,
          ),
          SizedBox(
            width: 65,
          ),
          MinusHomePlusButtons(),
          SizedBox(
            width: 65,
          ),
          XYABButtons(),
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnalogThumbStick(radius: 50.0, stickRadius: 35),
        SizedBox(
          width: 50.0,
        ),
        AnalogThumbStick(
            btnType: "RIGHT_ANALOG", radius: 50.0, stickRadius: 35),
      ])
    ]);
  }
}
