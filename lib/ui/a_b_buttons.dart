import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class ABButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PadRoundButton(btnType: "A", width: 65.0, height: 65.0),
        SizedBox(
          height: 15.0,
        ),
        PadRectangleButton(btnType: "B", width: 65.0, height: 85.0),
      ],
    );
  }
}
