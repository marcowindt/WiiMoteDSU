import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiimote_dsu/ui/a_b_buttons.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/layouts/device_layout.dart';
import 'package:wiimote_dsu/ui/minus_home_plus_buttons.dart';
import 'package:wiimote_dsu/ui/one_two_buttons.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';
import 'package:wiimote_dsu/ui/slot_display.dart';

class WiiMoteLayout extends StatelessWidget implements DeviceLayout {
  static const String name = "WiiMoteDSU";
  static const DeviceOrientation preferredOrientation =
      DeviceOrientation.portraitUp;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Dpad(size: screenSize.height * 0.25),
          SizedBox(height: screenSize.height * 0.2 / (3 * 4)),
          PadRectangleButton(
            btnType: "recenter",
            width: screenSize.width * 0.5,
            height: screenSize.height * 0.2 / (3 * 2),
          ),
          SizedBox(height: screenSize.height * 0.2 / (3 * 4)),
          ABButtons(
            width: screenSize.height * 0.25 / 3,
            height: screenSize.height * 0.25,
          ),
          SizedBox(height: screenSize.height * 0.2 / 3 - 20.0),
          MinusHomePlusButtons(
            width: screenSize.height * 0.15,
            height: screenSize.height * 0.15 / 4,
          ),
          SizedBox(height: screenSize.height * 0.2 / 3 - 20.0),
          OneTwoButtons(
            width: screenSize.height * 0.15 / 2.5,
            height: screenSize.height * 0.15,
          ),
          SlotDisplay(height: 40.0, padding: 10.0),
        ],
      ),
    );
  }
}
