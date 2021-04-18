import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class MinusHomePlusButtons extends StatelessWidget {
  final double width;
  final double height;

  const MinusHomePlusButtons(
      {Key key, this.width = 4.0 * 30, this.height = 1.0 * 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PadRoundButton(
            icon: Icons.remove,
            btnType: "MINUS",
            width: width / 3,
            height: height),
        PadRoundButton(
            icon: Icons.home,
            btnType: "HOME",
            width: width / 3,
            height: height),
        PadRoundButton(
            icon: Icons.add, btnType: "PLUS", width: width / 3, height: height),
      ],
    );
  }
}
