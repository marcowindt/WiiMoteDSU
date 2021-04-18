import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/devices/only_dpad_device.dart';
import 'package:wiimote_dsu/devices/wii_mote_device.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';

class DeviceSettings extends ChangeNotifier {
  static const List<String> available = [
    WiiMoteDevice.name,
    OnlyDpadDevice.name
  ];

  SharedPreferences preferences;
  String deviceName;

  DeviceSettings(this.preferences, this.deviceName);

  void setDeviceByName(String deviceName) {
    if (DeviceSettings.available.contains(deviceName)) {
      this.deviceName = deviceName;
    } else {
      this.deviceName = WiiMoteDevice.name;
    }
    notifyListeners();
  }

  Device createDevice(DSUServer server) {
    switch (this.deviceName) {
      case WiiMoteDevice.name:
        return WiiMoteDevice(server);
        break;
      case OnlyDpadDevice.name:
        return OnlyDpadDevice(server);
        break;
      default:
        return WiiMoteDevice(server);
    }
  }

  void clear() {
    this.setDeviceByName(WiiMoteDevice.name);
  }

  factory DeviceSettings.getSettings(SharedPreferences preferences) {
    String currentDevice =
        preferences.getString("current_device") ?? WiiMoteDevice.name;

    if (DeviceSettings.available.contains(currentDevice)) {
      return DeviceSettings(preferences, currentDevice);
    }
    return DeviceSettings(preferences, WiiMoteDevice.name);
  }
}
