import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

enum Direction {
  up,
  right,
  down,
  left,
}

class DPad extends StatefulWidget {
  final double size;
  final Function onUpdate;

  const DPad({Key key, @required this.size, @required this.onUpdate})
      : super(key: key);

  @override
  _DPadState createState() => _DPadState();
}

class _DPadState extends State<DPad> {
  Set<Direction> _pressedDirections = {};
  double get _radius => widget.size / 2;

  final List<Set<Direction>> sectors = [
    {Direction.up},
    {Direction.up, Direction.right},
    {Direction.right},
    {Direction.right, Direction.down},
    {Direction.down},
    {Direction.down, Direction.left},
    {Direction.left},
    {Direction.left, Direction.up},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Listener(
        onPointerDown: _onPointerUpdate,
        onPointerMove: _onPointerUpdate,
        onPointerUp: _onPointerUp,
        child: Container(
          width: widget.size,
          height: widget.size,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            color: Colors.grey.shade100,
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 10,
                  left: _radius - _radius / 4,
                  child: Container(
                      decoration: BoxDecoration(
                          color: _pressedDirections.contains(Direction.up)
                              ? Colors.black26
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      width: _radius / 2,
                      height: _radius - 24.0,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 24.0,
                        color: _pressedDirections.contains(Direction.up)
                            ? Colors.blue
                            : Colors.blueGrey,
                      ))),
              Positioned(
                  top: _radius - _radius / 4,
                  left: 10,
                  child: Container(
                      decoration: BoxDecoration(
                          color: _pressedDirections.contains(Direction.left)
                              ? Colors.black26
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      width: _radius - 24.0,
                      height: _radius / 2,
                      child: Icon(
                        Icons.arrow_back,
                        size: 24.0,
                        color: _pressedDirections.contains(Direction.left)
                            ? Colors.blue
                            : Colors.blueGrey,
                      ))),
              Positioned(
                top: _radius - _radius / 4,
                right: 10,
                child: Container(
                    decoration: BoxDecoration(
                        color: _pressedDirections.contains(Direction.right)
                            ? Colors.black26
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    width: _radius - 24.0,
                    height: _radius / 2,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 24.0,
                      color: _pressedDirections.contains(Direction.right)
                          ? Colors.blue
                          : Colors.blueGrey,
                    )),
              ),
              Positioned(
                  bottom: 10,
                  left: _radius - _radius / 4,
                  child: Container(
                      decoration: BoxDecoration(
                          color: _pressedDirections.contains(Direction.down)
                              ? Colors.black26
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      width: _radius / 2,
                      height: _radius - 24.0,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 24.0,
                        color: _pressedDirections.contains(Direction.down)
                            ? Colors.blue
                            : Colors.blueGrey,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void _onPointerUp(PointerEvent event) {
    setState(() {
      _pressedDirections.clear();
      widget.onUpdate(_pressedDirections);
    });
  }

  void _onPointerUpdate(PointerEvent event) {
    setState(() {
      _updatePressedDirections(event.localPosition);
    });
  }

  void _updatePressedDirections(Offset position) {
    final double dx = position.dx - _radius;
    final double dy = -position.dy + _radius;

    if (Offset(dx, dy).distance < _radius / 3) {
      // Middle dead zone
      _pressedDirections.clear();
      widget.onUpdate(_pressedDirections);
      return;
    }

    final double angle = math.atan2(dx, dy) % (2 * math.pi);
    final double degrees = angle * 180 / math.pi;
    final int sector = ((degrees + 22.5) ~/ 45) % 8;

    final newDirections = Set<Direction>.from(sectors[sector]);

    if (_pressedDirections.length != newDirections.length ||
        _pressedDirections.difference(newDirections).length > 0) {
      HapticFeedback.mediumImpact();
      _pressedDirections = newDirections;
      widget.onUpdate(_pressedDirections);
    }
  }
}
