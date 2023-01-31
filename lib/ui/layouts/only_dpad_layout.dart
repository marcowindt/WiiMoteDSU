import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/layouts/device_layout.dart';

class OnlyDpadLayout extends StatelessWidget implements DeviceLayout {
  static const String name = "OnlyDpad";
  static const DeviceOrientation preferredOrientation =
      DeviceOrientation.portraitUp;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Dpad(
              width: screenSize.height * 0.25,
              height: screenSize.height * 0.25,
            ),
          ],
        ));
  }
}
