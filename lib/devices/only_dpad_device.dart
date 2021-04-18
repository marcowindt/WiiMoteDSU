import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';
import 'package:wiimote_dsu/ui/layouts/only_dpad_layout.dart';

class OnlyDpadDevice extends Device {
  static const name = "OnlyDpad";

  @override
  String get deviceName => name;

  @override
  Widget getButtonLayout() {
    return OnlyDpadLayout();
  }

  OnlyDpadDevice(DSUServer server) : super(server);
}
