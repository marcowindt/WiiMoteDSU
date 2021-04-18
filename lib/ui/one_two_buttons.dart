import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class OneTwoButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PadRoundButton(btnType: "1", width: 45.0, height: 45.0),
        SizedBox(
          height: 15.0,
        ),
        PadRoundButton(btnType: "2", width: 45.0, height: 45.0),
      ],
    );
  }
}
