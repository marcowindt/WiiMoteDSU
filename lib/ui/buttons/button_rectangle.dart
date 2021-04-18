import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';

class PadRectangleButton extends StatelessWidget {
  final IconData icon;
  final String btnType;

  final double width;
  final double height;

  PadRectangleButton(
      {this.icon, this.btnType = "A", this.width = 65.0, this.height = 65.0});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        HapticFeedback.mediumImpact();
        context.read<DSUServer>().slots[0].setState(btnType, 0xFF);
      },
      onPointerUp: (details) {
        context.read<DSUServer>().slots[0].setState(btnType, 0x00);
      },
      child: MaterialButton(
        onPressed: () {},
        child: icon == null ? Text(btnType) : Icon(icon),
        height: height,
        minWidth: width,
        color: Colors.white70,
      ),
    );
  }
}
