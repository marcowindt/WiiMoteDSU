import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/ui/layouts/only_dpad_layout.dart';
import 'package:wiimote_dsu/ui/layouts/wii_classic_layout.dart';
import 'package:wiimote_dsu/ui/layouts/wii_mote_layout.dart';

class DeviceSettings extends ChangeNotifier {
  static const List<String> available = [
    WiiMoteLayout.name,
    OnlyDpadLayout.name,
    WiiClassicLayout.name
  ];

  SharedPreferences preferences;
  String? deviceName;
  DeviceOrientation? orientation;
  int slot;

  DeviceSettings(this.preferences, this.deviceName, this.orientation,
      {this.slot = 0});

  void setDeviceByName(String? deviceName) {
    if (DeviceSettings.available.contains(deviceName)) {
      this.deviceName = deviceName;
    } else {
      this.deviceName = WiiMoteLayout.name;
    }
    this.preferences.setString("current_device", this.deviceName!);
    notifyListeners();
  }

  void setDeviceOrientation(DeviceOrientation? orientation) {
    if (DeviceOrientation.values.contains(orientation)) {
      this.orientation = orientation;
    } else {
      this.orientation = DeviceOrientation.portraitUp;
    }
    this.preferences.setString(
        "device_orientation", this.orientation.toString().split(".")[1]);
    notifyListeners();
  }

  void setSlot(int slot) {
    this.slot = slot;
    this.preferences.setInt("device_slot", slot);
    notifyListeners();
  }

  Widget getButtonLayout() {
    switch (this.deviceName) {
      case WiiMoteLayout.name:
        return WiiMoteLayout();
      case OnlyDpadLayout.name:
        return OnlyDpadLayout();
      case WiiClassicLayout.name:
        return WiiClassicLayout();
      default:
        return WiiMoteLayout();
    }
  }

  List<DeviceOrientation> getPreferredOrientations() {
    switch (this.deviceName) {
      case WiiMoteLayout.name:
        return [WiiMoteLayout.preferredOrientation];
      case OnlyDpadLayout.name:
        return [OnlyDpadLayout.preferredOrientation];
      case WiiClassicLayout.name:
        return [WiiClassicLayout.preferredOrientation];
      default:
        return [WiiMoteLayout.preferredOrientation];
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

    int slot = preferences.getInt("device_slot") ?? 0;

    if (DeviceSettings.available.contains(currentDevice)) {
      return DeviceSettings(preferences, currentDevice, deviceOrientation,
          slot: slot);
    }
    return DeviceSettings(preferences, WiiMoteLayout.name, deviceOrientation,
        slot: slot);
  }
}
