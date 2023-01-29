import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';

class LZLRZRButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            PadRectangleButton(
              btnType: "ZL",
              height: 35,
            ),
            SizedBox(
              height: 10,
            ),
            PadRectangleButton(
              btnType: "L",
              height: 35,
            ),
          ],
        ),
        SizedBox(
          width: 500,
        ),
        Column(
          children: [
            PadRectangleButton(
              btnType: "ZR",
              height: 35,
            ),
            SizedBox(
              height: 10,
            ),
            PadRectangleButton(
              btnType: "R",
              height: 35,
            ),
          ],
        )
      ],
    );
  }
}
