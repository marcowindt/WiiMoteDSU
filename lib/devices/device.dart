import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/server/acc_event.dart';
import 'package:wiimote_dsu/server/gyro_event.dart';

class Device {
  static const name = "WiiMoteDSU";

  String get deviceName => name;

  SendPort serverSendPort;
  var disconnected = false;
  var mac = [0xFA, 0xCE, 0xB0, 0x0C, 0x00, 0x00];
  var model = 0x01;

  static const double PI = 3.1415926535897932;
  static const double METER_PER_SECOND_SQUARED_TO_G = 9.8066;

  GyroscopeEvent previousGyroEvent;
  GyroSettings gyroSettings;
  AccSettings accSettings;
  DeviceSettings deviceSettings;

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

  DeviceOrientation orientation = DeviceOrientation.portraitUp;

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

  void setState(String btnType, int state) {
    this.state[this.keyMap[btnType]] = state;
  }

  Device(GyroSettings gyroSettings, AccSettings accSettings,
      DeviceSettings deviceSettings, SendPort stream) {
    this.gyroSettings = gyroSettings;
    this.accSettings = accSettings;
    this.deviceSettings = deviceSettings;
    this.serverSendPort = stream;
    this.gyroSettings.addListener(onGyroSettingsChanged);
    this.accSettings.addListener(onAccSettingsChanged);
    this.deviceSettings.addListener(onDeviceSettingsChanged);
    try {
      this.initGyroSettings();
      this.initAccSettings();
      this.initDeviceSettings();
    } catch (error) {
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

  void initDeviceSettings() {
    orientation = deviceSettings.orientation;
  }

  void onGyroSettingsChanged() {
    initGyroSettings();
  }

  void onAccSettingsChanged() {
    initAccSettings();
  }

  void onDeviceSettingsChanged() {
    initDeviceSettings();
  }

  void start() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Values are in m/s^2, but we need in g's (1 g approx 9.8 m/s^2)
      if (!accEnabled) {
        return;
      }

      if (orientation == DeviceOrientation.portraitUp ||
          orientation == DeviceOrientation.portraitDown) {
        accX = meterSquaredToGs(event.x);
        accY = meterSquaredToGs(event.z);
        accZ = meterSquaredToGs(event.y);
      } else {
        accX = meterSquaredToGs(event.y);
        accY = meterSquaredToGs(event.z);
        accZ = meterSquaredToGs(event.x);
      }

      accX *= (invertAccX ? -1 : 1) * accSensitivity;
      accY *= (invertAccY ? -1 : 1) * accSensitivity;
      accZ *= (invertAccZ ? -1 : 1) * accSensitivity;

      serverSendPort.send(AccEvent(accX, accY, accZ));
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      // Values are in rad/s, but we need deg/s (2pi rad/s = 360 deg/s)
      // When in portrait: x = pitch, y = yaw, z = roll
      if (orientation == DeviceOrientation.portraitUp ||
          orientation == DeviceOrientation.portraitDown) {
        motionX = radToDeg(event.x);
        motionY = radToDeg(event.z);
        motionZ = radToDeg(event.y);
      } else {
        motionX = radToDeg(event.y);
        motionY = radToDeg(event.z);
        motionZ = radToDeg(event.x);
      }

      motionX *= (invertGyroX ? -1 : 1) * sensitivity;
      motionY *= (invertGyroY ? -1 : 1) * sensitivity;
      motionZ *= (invertGyroZ ? -1 : 1) * sensitivity;

      previousGyroEvent = event;

      serverSendPort.send(GyroEvent(motionX, motionY, motionZ));
    });
  }

  void setAcc(AccEvent accEvent) {
    accX = accEvent.x;
    accY = accEvent.y;
    accZ = accEvent.z;
  }

  void setGyro(GyroEvent gyroEvent) {
    motionX = gyroEvent.x;
    motionY = gyroEvent.y;
    motionZ = gyroEvent.z;
  }

  double meterSquaredToGs(double meterSquared) {
    return meterSquared * METER_PER_SECOND_SQUARED_TO_G / 100;
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
