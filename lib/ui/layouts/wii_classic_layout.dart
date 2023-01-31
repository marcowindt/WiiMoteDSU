import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/ui/analog_thumbstick.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/l_zl_r_zr_buttons.dart';
import 'package:wiimote_dsu/ui/layouts/device_layout.dart';
import 'package:wiimote_dsu/ui/minus_home_plus_buttons.dart';
import 'package:wiimote_dsu/ui/x_y_a_b_buttons.dart';

class WiiClassicLayout extends StatelessWidget implements DeviceLayout {
  static const String name = "WiiClassic";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          LZLRZRButtons(),
          SizedBox(
            height: 35,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dpad(
                width: 120,
                height: 120,
              ),
              SizedBox(
                width: 85,
              ),
              MinusHomePlusButtons(),
              SizedBox(
                width: 85,
              ),
              XYABButtons(),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnalogThumbStick(radius: 50.0, stickRadius: 35),
            SizedBox(
              width: 150.0,
            ),
            AnalogThumbStick(
                btnType: "RIGHT_ANALOG", radius: 50.0, stickRadius: 35),
          ])
        ]));
  }

  static const DeviceOrientation preferredOrientation =
      DeviceOrientation.landscapeRight;
}
