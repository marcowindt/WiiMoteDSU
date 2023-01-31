import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/ui/buttons/button_rectangle.dart';

class LZLRZRButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            PadRectangleButton(
              btnType: "ZL",
              height: 35,
            ),
            SizedBox(
              width: 20,
            ),
            PadRectangleButton(
              btnType: "L",
              height: 35,
            ),
          ],
        ),
        SizedBox(
          width: 300,
        ),
        Row(
          children: [
            PadRectangleButton(
              btnType: "R",
              height: 35,
            ),
            SizedBox(
              width: 20,
            ),
            PadRectangleButton(
              btnType: "ZR",
              height: 35,
            ),
          ],
        )
      ],
    );
  }
}
