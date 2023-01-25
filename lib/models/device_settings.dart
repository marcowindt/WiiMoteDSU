import 'package:flutter/services.dart';
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
  DeviceOrientation orientation;

  DeviceSettings(this.preferences, this.deviceName, this.orientation);

  void setDeviceByName(String deviceName) {
    if (DeviceSettings.available.contains(deviceName)) {
      this.deviceName = deviceName;
    } else {
      this.deviceName = WiiMoteLayout.name;
    }
    this.preferences.setString("current_device", this.deviceName);
    notifyListeners();
  }

  void setDeviceOrientation(DeviceOrientation orientation) {
    if (DeviceOrientation.values.contains(orientation)) {
      this.orientation = orientation;
    } else {
      this.orientation = DeviceOrientation.portraitUp;
    }
    this.preferences.setString(
        "device_orientation", this.orientation.toString().split(".")[1]);
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
    this.setDeviceOrientation(DeviceOrientation.portraitUp);
  }

  factory DeviceSettings.getSettings(SharedPreferences preferences) {
    String currentDevice =
        preferences.getString("current_device") ?? WiiMoteLayout.name;

    DeviceOrientation deviceOrientation = DeviceOrientation.values.firstWhere(
        (o) =>
            o.toString() ==
            "DeviceOrientation." +
                (preferences.getString("device_orientation") ?? "portraitUp"));

    if (DeviceSettings.available.contains(currentDevice)) {
      return DeviceSettings(preferences, currentDevice, deviceOrientation);
    }
    return DeviceSettings(preferences, WiiMoteLayout.name, deviceOrientation);
  }
}
