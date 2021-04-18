import 'package:flutter/material.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';
import 'package:wiimote_dsu/ui/layouts/wii_mote_layout.dart';

class WiiMoteDevice extends Device {
  @override
  Widget getButtonLayout() {
    return WiiMoteLayout();
  }

  WiiMoteDevice(
      DSUServer server, GyroSettings gyroSettings, AccSettings accSettings)
      : super(server, gyroSettings, accSettings);
}
