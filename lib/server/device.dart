import 'dart:async';

import 'dsu_server.dart';
import 'package:sensors/sensors.dart';

class Device {

  var server;
  var name = "WiiMoteDSU";
  var disconnected = false;
  var mac = [0xFA, 0xCE, 0xB0, 0x0C, 0x00, 0x00];
  var model = 0x01;

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

  Device(DSUServer server) {
    this.server = server;
    try {
      this.start();
    } catch (Error) {
      print("error");
    }
  }

  start() {
    accelerometerEvents.listen((event) {
      // Values are in m/s^2, but we need in g's (1 g approx 9.8 m/s^2)
      accX = 3 * -event.x * 9.81 / 100;
      accY = 3 * -event.z * 9.81 / 100;
      accZ = 3 * -event.y * 9.81 / 100; // / 4096;
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      // Values are in rad/s, but we need deg/s (2pi rad/s = 360 deg/s)
      motionX = 0.0; // -event.x * 180 / 3.14;
      motionY = 0.0; //-event.z * 180 / 3.14;
      motionZ = 0.0; //event.y * 180 / 3.14;
    });
  }

  getReport() {
    return state;
  }

}