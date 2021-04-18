import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';

class WiiMoteDevice extends Device {
  WiiMoteDevice(
      DSUServer server, GyroSettings gyroSettings, AccSettings accSettings)
      : super(server, gyroSettings, accSettings);
}
