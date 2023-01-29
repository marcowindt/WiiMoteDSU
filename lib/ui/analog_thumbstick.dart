import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/button_press.dart';
import 'package:wiimote_dsu/ui/buttons/thumbstick.dart';

class AnalogThumbStick extends StatelessWidget {
  final IconData icon;
  final String btnType;

  final double radius;
  final double stickRadius;

  AnalogThumbStick(
      {this.icon,
      this.btnType = "LEFT_ANALOG",
      this.radius = 50,
      this.stickRadius = 35});

  @override
  Widget build(BuildContext context) {
    return ThumbStick(
      radius: this.radius,
      stickRadius: this.stickRadius,
      callback: (x, y) {
        context.read<SendPort>().send(ButtonPress(btnType + "_X", x));
        context.read<SendPort>().send(ButtonPress(btnType + "_Y", y));
      },
    );
  }
}
