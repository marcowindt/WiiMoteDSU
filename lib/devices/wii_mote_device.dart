import 'package:flutter/material.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';
import 'package:wiimote_dsu/ui/layouts/wii_mote_layout.dart';

class WiiMoteDevice extends Device {
  static const name = "WiiMoteDSU";

  @override
  String get deviceName => name;

  @override
  Widget getButtonLayout() {
    return WiiMoteLayout();
  }

  WiiMoteDevice(DSUServer server) : super(server);
}
