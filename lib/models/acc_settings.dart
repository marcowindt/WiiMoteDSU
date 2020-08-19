import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccSettings extends ChangeNotifier {
  bool enabled = true;
  SharedPreferences preferences;
  bool adjustToDeviceOrientation = false;
  bool invertAccX = false;
  bool invertAccY = false;
  bool invertAccZ = false;
  double sensitivity = 3.0;

  AccSettings(
    this.preferences,
    this.enabled,
    this.adjustToDeviceOrientation,
    this.invertAccX,
    this.invertAccY,
    this.invertAccZ,
    this.sensitivity,
  );

  static bool getBool(SharedPreferences preferences, String key) {
    try {
      bool state = preferences.getBool(key);
      return state != null ? state : false;
    } catch (e) {
      return false;
    }
  }

  static int getInt(SharedPreferences preferences, String key) {
    try {
      int value = preferences.getInt(key);
      return value > 0 ? value : 1;
    } catch (e) {
      return 1;
    }
  }

  static double getDouble(SharedPreferences preferences, String key) {
    try {
      double value = preferences.getDouble(key);
      return value > 0 ? value : 1.0;
    } catch (e) {
      return 1.0;
    }
  }

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

  @override
  String toString() =>
      """adjustToDeviceOrientation: $adjustToDeviceOrientation, 
               invertGyroX: $invertAccX,
               invertGyroY: $invertAccY,
               invertGyroZ: $invertAccZ,
               sensitivity: $sensitivity""";
}
