import 'dart:math';

import 'package:flutter/material.dart';

class ThumbStick extends StatefulWidget {
  final double radius;
  final double stickRadius;
  final Function callback;

  const ThumbStick({Key key, this.radius, this.stickRadius, this.callback})
      : super(key: key);

  @override
  _ThumbStickState createState() => _ThumbStickState();
}

class _ThumbStickState extends State<ThumbStick> {
  final GlobalKey _thumbStickContainer = GlobalKey();
  double yOff = 0, xOff = 0;
  double _x = 0, _y = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final RenderBox renderBoxWidget =
          _thumbStickContainer.currentContext?.findRenderObject() as RenderBox;
      final offset = renderBoxWidget.localToGlobal(Offset.zero);

      xOff = offset.dx;
      yOff = offset.dy;
    });

    _centerStick();
  }

  void _centerStick() {
    setState(() {
      _x = widget.radius;
      _y = widget.radius;
    });

    _sendCoordinates(0, 0);
  }

  void _onPointerMove(PointerEvent details) {
    final x = details.position.dx - xOff;
    final y = details.position.dy - yOff;

    var xPos = x - widget.radius;
    var yPos = y - widget.radius;

    final angle = atan2(xPos, yPos);
    final distance = sqrt(pow(xPos, 2) + pow(yPos, 2));

    if (distance > widget.radius) {
      xPos = widget.radius * sin(angle);
      yPos = widget.radius * cos(angle);
    }

    debugPrint(
        "x ${xPos.floor()}, y ${yPos.floor()}, distance $distance, angle $angle");

    setState(() {
      _x = xPos + widget.radius;
      _y = yPos + widget.radius;
    });

    _sendCoordinates(xPos, yPos);
  }

  void _onPointerUp(PointerUpEvent event) {
    _centerStick();
  }

  void _sendCoordinates(double x, double y) {
    final xInput = ((x + widget.radius) * 255 / (widget.radius * 2)).floor();
    final yInput = ((y + widget.radius) * 255 / (widget.radius * 2)).floor();

    widget.callback(xInput, yInput);
  }

  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Container(
        key: _thumbStickContainer,
        width: widget.radius * 2,
        height: widget.radius * 2,
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Colors.grey.shade100,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: _x - widget.stickRadius,
              top: _y - widget.stickRadius,
              child: Container(
                width: widget.stickRadius * 2,
                height: widget.stickRadius * 2,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(widget.stickRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
