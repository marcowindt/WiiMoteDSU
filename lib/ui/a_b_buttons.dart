import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';
import 'package:wiimote_dsu/ui/buttons/button_round.dart';

class ABButtons extends StatelessWidget {
  final double width;
  final double height;

  const ABButtons({Key? key, this.width = 1.0 * 60, this.height = 3.0 * 60})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: PadRoundButton(
              btnType: "A",
              width: width,
              height: .4 * height,
            ),
          ),
          SizedBox(height: height * 0.1),
          Positioned(
            bottom: 0,
            child: PadRectangleButton(
              btnType: "B",
              width: width,
              height: .5 * height,
            ),
          ),
        ],
      ),
    );
  }
}
