import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/button_press.dart';

class DpadArrow extends StatelessWidget {
  final IconData iconData;
  final String btnType;

  final double width;
  final double height;

  DpadArrow(this.iconData,
      {this.btnType = "D_UP", this.width = 50.0, this.height = 80.0});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        HapticFeedback.mediumImpact();
        context.read<SendPort>().send(ButtonPress(btnType, 0xFF));
      },
      onPointerUp: (details) {
        context.read<SendPort>().send(ButtonPress(btnType, 0x00));
      },
      child: SizedBox(
        width: width,
        height: height,
        child: MaterialButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: () {},
          color: Colors.white70,
          child: Icon(
            iconData,
            size: (height < width ? height : width) * 0.7,
          ),
        ),
      ),
    );
  }
}
