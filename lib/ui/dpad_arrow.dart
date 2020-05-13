import 'package:flutter/material.dart';

class DpadArrow extends StatelessWidget {
  IconData iconData;
  bool upOrDown = false;
  String btnType = "D_UP";

  Function onDown;
  Function onUp;

  DpadArrow(IconData iconData, String btnType, bool upOrDown, Function onDown, Function onUp) {
    this.iconData = iconData;
    this.btnType = btnType;
    this.upOrDown = upOrDown;
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
          height: upOrDown ? 80.0 : 50.0,
          minWidth: upOrDown ? 40.0 : 80.0,
          child: Icon(iconData),
          color: Colors.white70,
      ),
    );
  }



}