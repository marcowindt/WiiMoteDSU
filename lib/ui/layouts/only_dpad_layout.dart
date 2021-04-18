import 'package:flutter/material.dart';
import 'package:wiimote_dsu/ui/dpad.dart';

class OnlyDpadLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Dpad(
              width: screenSize.height * 0.25,
              height: screenSize.height * 0.25,
            ),
          ],
        ));
  }
}
