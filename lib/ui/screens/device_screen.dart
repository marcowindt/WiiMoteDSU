import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Provider.of<DSUServer>(context).slots[0].getButtonLayout(),
    );
  }
}
