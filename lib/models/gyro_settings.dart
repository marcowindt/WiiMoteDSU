import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GyroSettings extends ChangeNotifier {
  SharedPreferences preferences;
  bool adjustToDeviceOrientation = false;
  bool invertGyroX = false;
  bool invertGyroY = true;
  bool invertGyroZ = false;
  double sensitivity = 1.0;

  GyroSettings(
    this.preferences,
    this.adjustToDeviceOrientation,
    this.invertGyroX,
    this.invertGyroY,
    this.invertGyroZ,
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

  void setAdjustToDeviceOrientation(bool value) {
    adjustToDeviceOrientation = value;
    notifyListeners();
    preferences.setBool('adjust_gyro_orientation', value);
  }

  void setInvertGyroX(bool value) {
    invertGyroX = value;
    notifyListeners();
    preferences.setBool('invert_gyro_x', value);
  }

  void setInvertGyroY(bool value) {
    invertGyroY = value;
    notifyListeners();
    preferences.setBool('invert_gyro_y', value);
  }

  void setInvertGyroZ(bool value) {
    invertGyroZ = value;
    notifyListeners();
    preferences.setBool('invert_gyro_z', value);
  }

  void setGyroSensitivity(double value) {
    sensitivity = value;
    notifyListeners();
    preferences.setDouble('gyro_sensitivity', value);
  }

  void clear() {
    adjustToDeviceOrientation = false;
    invertGyroX = false;
    invertGyroY = true;
    invertGyroZ = false;
    sensitivity = 1.0;
    notifyListeners();
  }

  @override
  String toString() =>
      """adjustToDeviceOrientation: $adjustToDeviceOrientation, 
               invertGyroX: $invertGyroX,
               invertGyroY: $invertGyroY,
               invertGyroZ: $invertGyroZ,
               sensitivity: $sensitivity""";
}
