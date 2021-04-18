import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class MinusHomePlusButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PadRoundButton(
            icon: Icons.remove, btnType: "MINUS", width: 30.0, height: 30.0),
        PadRoundButton(
            icon: Icons.home, btnType: "HOME", width: 30.0, height: 30.0),
        PadRoundButton(
            icon: Icons.add, btnType: "PLUS", width: 30.0, height: 30.0),
      ],
    );
  }
}
