import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<DeviceSettings>(
        builder: (BuildContext context, DeviceSettings settings, Widget child) {
      return settings.getButtonLayout();
    }));
  }
}
