import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class XYABButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PadRoundButton(
          btnType: "x",
          width: 45,
          height: 45,
          color: Colors.white,
        ),
        Row(
          children: [
            PadRoundButton(
              btnType: "y",
              width: 45,
              height: 45,
              color: Colors.white,
            ),
            SizedBox(
              width: 45,
            ),
            PadRoundButton(btnType: "a", width: 45, height: 45),
          ],
        ),
        PadRoundButton(btnType: "b", width: 45, height: 45),
      ],
    );
  }
}
