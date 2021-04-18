import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/a_b_buttons.dart';
import 'package:wiimote_dsu/ui/dpad.dart';
import 'package:wiimote_dsu/ui/minus_home_plus_buttons.dart';
import 'package:wiimote_dsu/ui/one_two_buttons.dart';

class WiiMoteLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Dpad(),
        SizedBox(
          height: 50.0,
        ),
        ABButtons(),
        SizedBox(
          height: 50.0,
        ),
        MinusHomePlusButtons(),
        SizedBox(
          height: 50.0,
        ),
        OneTwoButtons(),
      ],
    );
  }
}
