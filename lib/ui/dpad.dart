import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/buttons/dpad_arrow.dart';

class Dpad extends StatelessWidget {
  final double width;
  final double height;

  Dpad({this.width = 180.0, this.height = 180.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.amber,
        width: width,
        height: height,
        child: Stack(children: <Widget>[
          Positioned(
            left: width * 0.5 - 0.125 * width,
            top: 0,
            child: DpadArrow(
              Icons.arrow_upward,
              btnType: "D_UP",
              width: 0.25 * width,
              height: 0.4 * height,
            ),
          ),
          Positioned(
              left: 0,
              top: height * 0.5 - 0.125 * height,
              child: DpadArrow(
                Icons.arrow_back,
                btnType: "D_LEFT",
                width: 0.4 * width,
                height: 0.25 * height,
              )),
          Positioned(
              right: 0,
              top: height * 0.5 - 0.125 * height,
              child: DpadArrow(
                Icons.arrow_forward,
                btnType: "D_RIGHT",
                width: 0.4 * width,
                height: 0.25 * height,
              )),
          Positioned(
              bottom: 0,
              left: width * 0.5 - 0.125 * width,
              child: DpadArrow(
                Icons.arrow_downward,
                btnType: "D_DOWN",
                width: 0.25 * width,
                height: 0.4 * height,
              )),
        ]));
  }
}
