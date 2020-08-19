import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Consumer2<GyroSettings, AccSettings>(builder:
            (BuildContext context, GyroSettings gyroSettings,
                AccSettings accSettings, Widget child) {
          return ListView(
            children: [
              // ListTile(
              //   title: Text('Auto adjust to device orientation'),
              //   trailing: Checkbox(
              //     value: gyroSettings.adjustToDeviceOrientation,
              //     onChanged: (bool value) =>
              //         gyroSettings.setAdjustToDeviceOrientation(value),
              //   ),
              // ),
              ListTile(
                title: Text('Acc Enabled'),
                trailing: Checkbox(
                  value: accSettings.enabled,
                  onChanged: (bool value) => accSettings.setAccEnabled(value),
                ),
              ),
              ListTile(
                title: Text('Invert Acc X'),
                trailing: Checkbox(
                  value: accSettings.invertAccX,
                  onChanged: (bool value) => accSettings.setInvertAccX(value),
                ),
              ),
              ListTile(
                title: Text('Invert Acc Y'),
                trailing: Checkbox(
                  value: accSettings.invertAccY,
                  onChanged: (bool value) => accSettings.setInvertAccY(value),
                ),
              ),
              ListTile(
                title: Text('Invert Acc Z'),
                trailing: Checkbox(
                  value: accSettings.invertAccZ,
                  onChanged: (bool value) => accSettings.setInvertAccZ(value),
                ),
              ),
              ListTile(
                title: Text('Invert Gryo X'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroX,
                  onChanged: (bool value) => gyroSettings.setInvertGyroX(value),
                ),
              ),
              ListTile(
                title: Text('Invert Gryo Y'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroY,
                  onChanged: (bool value) => gyroSettings.setInvertGyroY(value),
                ),
              ),
              ListTile(
                title: Text('Invert Gryo Z'),
                trailing: Checkbox(
                  value: gyroSettings.invertGyroZ,
                  onChanged: (bool value) => gyroSettings.setInvertGyroZ(value),
                ),
              ),
              ListTile(
                title: Text('Gyroscope Sensitivity'),
                subtitle: Slider(
                  value: gyroSettings.sensitivity,
                  min: 1,
                  max: 50,
                  divisions: 200,
                  label: gyroSettings.sensitivity.round().toString(),
                  onChanged: (double value) {
                    gyroSettings.setGyroSensitivity(value);
                  },
                ),
              )
            ],
          );
        }));
  }

  bool getPref(SharedPreferences prefs, String key) {
    try {
      bool state = prefs.getBool(key);
      return (state != null) ? state : false;
    } catch (e) {
      return false;
    }
  }
}
