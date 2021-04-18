import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class OneTwoButtons extends StatelessWidget {
  final double width;
  final double height;

  const OneTwoButtons(
      {Key key, this.width = 1.0 * 45.0, this.height = 2.5 * 45.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: PadRoundButton(
                  btnType: "1", width: width, height: height / 2.5),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: PadRoundButton(
                  btnType: "2", width: width, height: height / 2.5),
            ),
          ],
        ));
  }
}
