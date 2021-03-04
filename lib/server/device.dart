import 'dart:async';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

import 'dsu_server.dart';
import 'package:sensors/sensors.dart';

class Device {
  var server;
  var name = "WiiMoteDSU";
  var disconnected = false;
  var mac = [0xFA, 0xCE, 0xB0, 0x0C, 0x00, 0x00];
  var model = 0x01;

  static const double PI = 3.1415926535897932;
  static const double METER_PER_SECOND_SQUARED_TO_G = 9.8066;

  GyroscopeEvent previousGyroEvent;
  GyroSettings gyroSettings;
  AccSettings accSettings;

  // Gyroscope specific
  bool adjustToDeviceOrientation = false;
  bool invertGyroX = false;
  bool invertGyroY = false;
  bool invertGyroZ = false;
  double sensitivity = 1.0;

  // Accelerometer specific
  bool accEnabled = true;
  bool adjustToDeviceOrientationAcc = false;
  bool invertAccX = false;
  bool invertAccY = false;
  bool invertAccZ = false;
  double accSensitivity = 1.0;

  double motionX = 0;
  double motionY = 0;
  double motionZ = 0;

  double accX = 0;
  double accY = 0;
  double accZ = 0;

  StreamSubscription<dynamic> motion;

  var keyMap = {
    "D_UP": "dpad_up",
    "D_RIGHT": "dpad_right",
    "D_DOWN": "dpad_down",
    "D_LEFT": "dpad_left",
    "A": "button_cross",
    "B": "button_square",
    "1": "button_triangle",
    "2": "button_circle",
    "MINUS": "button_share",
    "PLUS": "button_options",
    "HOME": "button_ps",
  };

  var state = {
    "left_analog_x": 0x00,
    "left_analog_y": 0x00,
    "right_analog_x": 0x00,
    "right_analog_y": 0x00,
    "dpad_up": 0x00,
    "dpad_down": 0x00,
    "dpad_left": 0x00,
    "dpad_right": 0x00,
    "button_cross": 0x00,
    "button_circle": 0x00,
    "button_square": 0x00,
    "button_triangle": 0x00,
    "button_l1": 0x00,
    "button_l2": 0x00,
    "button_l3": 0x00,
    "button_r1": 0x00,
    "button_r2": 0x00,
    "button_r3": 0x00,
    "button_share": 0x00,
    "button_options": 0x00,
    "button_ps": 0x00,
    "motion_y": 0x00,
    "motion_x": 0x00,
    "motion_z": 0x00,
    "orientation_roll": 0x00,
    "orientation_yaw": 0x00,
    "orientation_pitch": 0x00,
    "timestamp": 0x00,
    "battery": 0x05
  };

  Device(DSUServer server, GyroSettings gyroSettings, AccSettings accSettings) {
    this.server = server;
    this.gyroSettings = gyroSettings;
    this.accSettings = accSettings;
    gyroSettings.addListener(onGyroSettingsChanged);
    accSettings.addListener(onAccSettingsChanged);
    try {
      this.start();
      this.initGyroSettings();
      this.initAccSettings();
    } catch (Error) {
      print("error");
    }
  }

  void initGyroSettings() {
    adjustToDeviceOrientation = gyroSettings.adjustToDeviceOrientation;
    invertGyroX = gyroSettings.invertGyroX;
    invertGyroY = gyroSettings.invertGyroY;
    invertGyroZ = gyroSettings.invertGyroZ;
    sensitivity = gyroSettings.sensitivity;
  }

  void initAccSettings() {
    accEnabled = accSettings.enabled;
    adjustToDeviceOrientationAcc = accSettings.adjustToDeviceOrientation;
    invertAccX = accSettings.invertAccX;
    invertAccY = accSettings.invertAccY;
    invertAccZ = accSettings.invertAccZ;
    accSensitivity = accSettings.sensitivity;
  }

  void onGyroSettingsChanged() {
    initGyroSettings();
    // debugPrint('gyro settings changed: \n $gyroSettings');
  }

  void onAccSettingsChanged() {
    initAccSettings();
    // debugPrint('acc settings changed: \n $accSettings');
  }

  void start() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Values are in m/s^2, but we need in g's (1 g approx 9.8 m/s^2)
      if (accEnabled) {
        accX = (invertAccX ? -1 : 1) *
            accSensitivity *
            event.x *
            METER_PER_SECOND_SQUARED_TO_G /
            100;
        accY = (invertAccY ? -1 : 1) *
            accSensitivity *
            event.z *
            METER_PER_SECOND_SQUARED_TO_G /
            100;
        accZ = (invertAccZ ? -1 : 1) *
            accSensitivity *
            event.y *
            METER_PER_SECOND_SQUARED_TO_G /
            100;
      } else {
        accX = 0;
        accY = 0;
        accZ = 0;
      }
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      // Values are in rad/s, but we need deg/s (2pi rad/s = 360 deg/s)
      // When in portrait: x = pitch, y = yaw, z = roll
      motionX = (invertGyroX ? -1 : 1) * radToDeg(event.x) * sensitivity;
      motionY = (invertGyroY ? -1 : 1) * radToDeg(event.z) * sensitivity;
      motionZ = (invertGyroZ ? -1 : 1) * radToDeg(event.y) * sensitivity;
      previousGyroEvent = event;
    });
  }

  double radToDeg(double radians) {
    return radians * 180 / PI;
  }

  int orientationAdjusted() {
    throw UnimplementedError('TODO');
  }

  getReport() {
    return state;
  }
}
