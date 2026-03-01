import 'package:flutter/services.dart';

abstract class DeviceLayout {
  static String? name;
  static DeviceOrientation preferredOrientation = DeviceOrientation.portraitUp;
}
