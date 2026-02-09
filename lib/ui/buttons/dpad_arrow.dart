import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/server/events/button_event.dart';

class DpadArrow extends StatelessWidget {
  final IconData iconData;
  final String btnType;

  final double width;
  final double height;

  DpadArrow(this.iconData,
      {this.btnType = "D_UP", this.width = 50.0, this.height = 80.0});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceSettings>(
        builder: (BuildContext context, DeviceSettings settings, Widget? child) {
      return Listener(
        onPointerDown: (details) {
          HapticFeedback.mediumImpact();
          context
              .read<SendPort>()
              .send(ButtonEvent(settings.slot, btnType, 0xFF));
        },
        onPointerUp: (details) {
          context
              .read<SendPort>()
              .send(ButtonEvent(settings.slot, btnType, 0x00));
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
    });
  }
}
