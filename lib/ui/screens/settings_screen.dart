import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  late TextEditingController controller;
  final networkInfo = NetworkInfo();

  @override
  void initState() {
    controller = TextEditingController(
      text: '26760',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Consumer3<GyroSettings, AccSettings, DeviceSettings>(builder:
            (BuildContext context,
                GyroSettings gyroSettings,
                AccSettings accSettings,
                DeviceSettings deviceSettings,
                Widget? child) {
          return ListView(
            children: [
              ListTile(
                title: Text('Slot'),
                trailing: DropdownButton<int>(
                  hint: Text("Select slot"),
                  value: Provider.of<DeviceSettings>(context).slot,
                  onChanged: (int? slot) {
                    context.read<DeviceSettings>().setSlot(slot!);
                  },
                  items: [0, 1, 2, 3].map((slot) {
                    return DropdownMenuItem<int>(
                      value: slot,
                      child: Text("$slot"),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text('Device Orientation'),
                trailing: DropdownButton<DeviceOrientation>(
                  hint: Text("Select orientation"),
                  value: Provider.of<DeviceSettings>(context).orientation,
                  onChanged: (DeviceOrientation? orientation) {
                    context
                        .read<DeviceSettings>()
                        .setDeviceOrientation(orientation!);
                  },
                  items: DeviceOrientation.values.map((orientation) {
                    return DropdownMenuItem<DeviceOrientation>(
                      value: orientation,
                      child: Text(orientation.toString().split(".")[1]),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text('Acc Enabled'),
                trailing: Checkbox(
                  value: accSettings.enabled,
                  onChanged: (bool? value) => accSettings.setAccEnabled(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Acc X'),
                trailing: Checkbox(
                  value: accSettings.invertAccX,
                  onChanged: (bool? value) => accSettings.setInvertAccX(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Acc Y'),
                trailing: Checkbox(
                  value: accSettings.invertAccY,
                  onChanged: (bool? value) => accSettings.setInvertAccY(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Acc Z'),
                trailing: Checkbox(
                  value: accSettings.invertAccZ,
                  onChanged: (bool? value) => accSettings.setInvertAccZ(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Gyro X'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroX,
                  onChanged: (bool? value) =>
                      gyroSettings.setInvertGyroX(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Gyro Y'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroY,
                  onChanged: (bool? value) =>
                      gyroSettings.setInvertGyroY(value!),
                ),
              ),
              ListTile(
                title: Text('Invert Gyro Z'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroZ,
                  onChanged: (bool? value) =>
                      gyroSettings.setInvertGyroZ(value!),
                ),
              ),
              ListTile(
                title: Text('Gyroscope Sensitivity'),
                subtitle: Slider(
                  value: gyroSettings.sensitivity,
                  min: 0,
                  max: 2,
                  divisions: 200,
                  label: gyroSettings.sensitivity.toStringAsFixed(2),
                  onChanged: (double value) {
                    gyroSettings.setGyroSensitivity(value);
                  },
                ),
              ),
              ListTile(
                title: Text("Device"),
                trailing: DropdownButton<String>(
                  hint: Text("Select device"),
                  value: Provider.of<DeviceSettings>(context).deviceName,
                  onChanged: (String? name) {
                    context.read<DeviceSettings>().setDeviceByName(name);
                  },
                  items: DeviceSettings.available.map((String deviceName) {
                    return DropdownMenuItem<String>(
                      value: deviceName,
                      child: Text(deviceName),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text('IP Address'),
                trailing: FutureBuilder(
                  future: networkInfo.getWifiIP(),
                  builder: (BuildContext context, AsyncSnapshot<String?> ip) {
                    if (ip.hasData) {
                      return Text('${ip.data!}');
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              ListTile(
                title: Text('Port'),
                trailing: Text('${controller.text}'),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => clearCachedSettings(
                          accSettings, gyroSettings, deviceSettings),
                      child: Text('Reset to default'))),
            ],
          );
        }));
  }

  Future<bool> clearCachedSettings(AccSettings accSettings,
      GyroSettings gyroSettings, DeviceSettings deviceSettings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool cleared = await preferences.clear();
    accSettings.clear();
    gyroSettings.clear();
    deviceSettings.clear();
    return cleared;
  }
}
