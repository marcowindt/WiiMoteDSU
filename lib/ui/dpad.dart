import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/server/events/multi_button_event.dart';
import 'package:wiimote_dsu/ui/buttons/multi_dpad.dart';

class Dpad extends StatelessWidget {
  final double size;

  Dpad({this.size = 120.0});

  static const DSUButtons = {
    Direction.up: "D_UP",
    Direction.right: "D_RIGHT",
    Direction.down: "D_DOWN",
    Direction.left: "D_LEFT"
  };

  static const offState = {
    "D_UP": 0x00,
    "D_RIGHT": 0x00,
    "D_DOWN": 0x00,
    "D_LEFT": 0x00,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceSettings>(
        builder: (BuildContext context, DeviceSettings settings, Widget child) {
      return DPad(
          size: size,
          onUpdate: (Set<Direction> directionsPressed) {
            final mappedDirections =
                directionsPressed.map((direction) => DSUButtons[direction]);
            context.read<SendPort>().send(MultiButtonEvent(settings.slot,
                    offState.map((dArrow, state) {
                  if (mappedDirections.contains(dArrow)) {
                    return MapEntry(dArrow, 0xFF);
                  } else {
                    return MapEntry(dArrow, 0x00);
                  }
                })));
          });
    });
  }
}
