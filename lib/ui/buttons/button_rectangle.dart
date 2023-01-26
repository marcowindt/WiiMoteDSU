import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/button_press.dart';

class PadRectangleButton extends StatelessWidget {
  final IconData icon;
  final String btnType;

  final double width;
  final double height;

  PadRectangleButton(
      {this.icon, this.btnType = "A", this.width = 65.0, this.height = 65.0});

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
          child: icon == null
              ? Text(
                  btnType,
                  style: TextStyle(
                      fontSize: (width < height ? width : height) * 0.3),
                )
              : Icon(
                  icon,
                  size: (width < height ? width : height) * 0.7,
                ),
          height: height,
          minWidth: width,
          color: Colors.white70,
        ),
      ),
    );
  }
}
