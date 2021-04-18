import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/dpad_arrow.dart';

class Dpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DpadArrow(Icons.arrow_upward, btnType: "D_UP", upOrDown: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DpadArrow(Icons.arrow_back, btnType: "D_LEFT", upOrDown: false),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
              ),
              DpadArrow(Icons.arrow_forward,
                  btnType: "D_RIGHT", upOrDown: false),
            ],
          ),
          DpadArrow(Icons.arrow_downward, btnType: "D_DOWN", upOrDown: true),
        ]);
  }
}
