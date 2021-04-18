import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';

class DpadArrow extends StatelessWidget {
  final IconData iconData;
  final String btnType;
  final bool upOrDown;

  DpadArrow(this.iconData, {this.btnType = "D_UP", this.upOrDown = false});

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
        height: upOrDown ? 80.0 : 50.0,
        minWidth: upOrDown ? 40.0 : 80.0,
        child: Icon(iconData),
        color: Colors.white70,
      ),
    );
  }
}
