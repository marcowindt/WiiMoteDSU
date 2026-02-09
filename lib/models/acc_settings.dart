import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccSettings extends ChangeNotifier {
  bool enabled = true;
  SharedPreferences preferences;
  bool adjustToDeviceOrientation = false;
  bool invertAccX = true;
  bool invertAccY = true;
  bool invertAccZ = false;
  double sensitivity = 1.0;

  AccSettings(
    this.preferences,
    this.enabled,
    this.adjustToDeviceOrientation,
    this.invertAccX,
    this.invertAccY,
    this.invertAccZ,
    this.sensitivity,
  );

  void setAccEnabled(bool value) {
    enabled = value;
    notifyListeners();
    preferences.setBool('acc_enabled', value);
  }

  void setAdjustToDeviceOrientation(bool value) {
    adjustToDeviceOrientation = value;
    notifyListeners();
    preferences.setBool('adjust_acc_orientation', value);
  }

  void setInvertAccX(bool value) {
    invertAccX = value;
    notifyListeners();
    preferences.setBool('invert_acc_x', value);
  }

  void setInvertAccY(bool value) {
    invertAccY = value;
    notifyListeners();
    preferences.setBool('invert_acc_y', value);
  }

  void setInvertAccZ(bool value) {
    invertAccZ = value;
    notifyListeners();
    preferences.setBool('invert_acc_z', value);
  }

  void setGyroSensitivity(double value) {
    sensitivity = value;
    notifyListeners();
    preferences.setDouble('acc_sensitivity', value);
  }

  void clear() {
    enabled = true;
    adjustToDeviceOrientation = false;
    invertAccX = true;
    invertAccY = true;
    invertAccZ = false;
    sensitivity = 1.0;
    notifyListeners();
  }

  factory AccSettings.getSettings(SharedPreferences preferences) {
    return AccSettings(
      preferences,
      preferences.getBool('acc_enabled') != null
          ? preferences.getBool('acc_enabled')!
          : true,
      preferences.getBool('adjust_acc_orientation') != null
          ? preferences.getBool('adjust_acc_orientation')!
          : false,
      preferences.getBool('invert_acc_x') != null
          ? preferences.getBool('invert_acc_x')!
          : true,
      preferences.getBool('invert_acc_y') != null
          ? preferences.getBool('invert_acc_y')!
          : true,
      preferences.getBool('invert_acc_z') != null
          ? preferences.getBool('invert_acc_z')!
          : false,
      preferences.getDouble('acc_sensitivity') != null
          ? preferences.getDouble('acc_sensitivity')!
          : 1.0,
    );
  }

  @override
  String toString() =>
      """adjustToDeviceOrientation: $adjustToDeviceOrientation, 
               invertAccX: $invertAccX,
               invertAccY: $invertAccY,
               invertAccZ: $invertAccZ,
               sensitivity: $sensitivity""";
}
