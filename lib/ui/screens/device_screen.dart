import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';

class DeviceScreen extends StatefulWidget {
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final deviceSettings = Provider.of<DeviceSettings>(context);
    SystemChrome.setPreferredOrientations(
        deviceSettings.getPreferredOrientations());
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<DeviceSettings>(
        builder: (BuildContext context, DeviceSettings settings, Widget child) {
      return settings.getButtonLayout();
    }));
  }
}
