import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GyroSettings extends ChangeNotifier {
  SharedPreferences preferences;
  bool? adjustToDeviceOrientation = false;
  bool? invertGyroX = false;
  bool? invertGyroY = true;
  bool? invertGyroZ = false;
  double? sensitivity = 1.0;

  GyroSettings(
    this.preferences,
    this.adjustToDeviceOrientation,
    this.invertGyroX,
    this.invertGyroY,
    this.invertGyroZ,
    this.sensitivity,
  );

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

  factory GyroSettings.getSettings(SharedPreferences preferences) {
    return GyroSettings(
      preferences,
      preferences.getBool('adjust_gyro_orientation') != null
          ? preferences.getBool('adjust_gyro_orientation')!
          : false,
      preferences.getBool('invert_gyro_x') != null
          ? preferences.getBool('invert_gyro_x')!
          : false,
      preferences.getBool('invert_gyro_y') != null
          ? preferences.getBool('invert_gyro_y')!
          : true,
      preferences.getBool('invert_gyro_z') != null
          ? preferences.getBool('invert_gyro_z')!
          : false,
      preferences.getDouble('gyro_sensitivity') != null
          ? preferences.getDouble('gyro_sensitivity')!
          : 1.0,
    );
  }

  @override
  String toString() =>
      """adjustToDeviceOrientation: $adjustToDeviceOrientation, 
               invertGyroX: $invertGyroX,
               invertGyroY: $invertGyroY,
               invertGyroZ: $invertGyroZ,
               sensitivity: $sensitivity""";
}
