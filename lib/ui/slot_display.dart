import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wiimote_dsu/models/device_settings.dart';

class SlotDisplay extends StatelessWidget {
  final double height;
  final double padding;

  const SlotDisplay({Key? key, required this.height, required this.padding})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceSettings>(
      builder: (context, settings, child) {
        List<Widget> children = [];
        for (
          var slot = 0;
          slot < 4 /* TODO(ethan): Don't hard code */;
          slot++
        ) {
          children.add(
            SizedBox(
              width: this.height,
              height: this.height,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                icon: Icon(
                  size: this.height - this.padding * 2,
                  fill: 0.0,
                  slot == settings.slot
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                onPressed: null,
              ),
            ),
          );
        }
        return SizedBox(
          height: this.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 0.0,
            children: children,
          ),
        );
      },
    );
  }
}
