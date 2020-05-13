import 'package:flutter/material.dart';

class PadRectangleButton extends StatelessWidget {
  IconData iconData;
  String btnType = "A";

  double width = 65.0;
  double height = 65.0;

  Function onDown;
  Function onUp;

  PadRectangleButton(IconData iconData, String btnType, double width, double height, Function onDown, Function onUp) {
    this.iconData = iconData;
    this.btnType = btnType;
    this.width = width;
    this.height = height;
    this.onDown = onDown;
    this.onUp = onUp;
  }


  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) { onDown(btnType); },
      onPointerUp: (details) { onUp(btnType); },
      child: MaterialButton(
        onPressed: () {},
        child: iconData == null ? Text(btnType) : Icon(iconData),
        height: height,
        minWidth: width,
        color: Colors.white70,
      ),
    );
  }

}