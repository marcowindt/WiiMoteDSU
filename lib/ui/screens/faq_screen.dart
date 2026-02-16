import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/acc_settings.dart';
import 'package:wiimote_dsu/models/device_settings.dart';
import 'package:wiimote_dsu/models/gyro_settings.dart';

class FaqScreen extends StatefulWidget {
  _FaqScreen createState() => _FaqScreen();
}

class _FaqScreen extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQ'),
        ),
        body: Consumer3<GyroSettings, AccSettings, DeviceSettings>(builder:
            (BuildContext context,
                GyroSettings gyroSettings,
                AccSettings accSettings,
                DeviceSettings deviceSettings,
                Widget? child) {
          return ListView(
            children: [
            ],
          );
        }));
  }
}
