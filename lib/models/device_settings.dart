import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/ui/layouts/only_dpad_layout.dart';
import 'package:wiimote_dsu/ui/layouts/wii_mote_layout.dart';

class DeviceSettings extends ChangeNotifier {
  static const List<String> available = [
    WiiMoteLayout.name,
    OnlyDpadLayout.name
  ];

  SharedPreferences preferences;
  String deviceName;

  DeviceSettings(this.preferences, this.deviceName);

  void setDeviceByName(String deviceName) {
    if (DeviceSettings.available.contains(deviceName)) {
      this.deviceName = deviceName;
    } else {
      this.deviceName = WiiMoteLayout.name;
    }
    notifyListeners();
  }

  Widget getButtonLayout() {
    switch (this.deviceName) {
      case WiiMoteLayout.name:
        return WiiMoteLayout();
        break;
      case OnlyDpadLayout.name:
        return OnlyDpadLayout();
        break;
      default:
        return WiiMoteLayout();
    }
  }

  void clear() {
    this.setDeviceByName(WiiMoteLayout.name);
  }

  factory DeviceSettings.getSettings(SharedPreferences preferences) {
    String currentDevice =
        preferences.getString("current_device") ?? WiiMoteLayout.name;

    if (DeviceSettings.available.contains(currentDevice)) {
      return DeviceSettings(preferences, currentDevice);
    }
    return DeviceSettings(preferences, WiiMoteLayout.name);
  }
}
