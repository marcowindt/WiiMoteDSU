import 'dart:async';
import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:wiimote_dsu/devices/device.dart';
import 'package:wiimote_dsu/server/dsu_server.dart';
import 'package:wiimote_dsu/server/events/acc_event.dart';
import 'package:wiimote_dsu/server/events/button_event.dart';
import 'package:wiimote_dsu/server/events/change_slot_event.dart';
import 'package:wiimote_dsu/server/events/gyro_event.dart';
import 'package:wiimote_dsu/server/events/multi_button_event.dart';

class ServerIsolate {
  static Future<SendPort> init() async {
    final server = DSUServer.make();

    Completer completer = Completer<SendPort>();
    final isolateToMainStream = ReceivePort();

    isolateToMainStream.listen((data) {
      if (data is SendPort) {
        final mainToIsolateStream = data;
        completer.complete(mainToIsolateStream);
      } else {
        print('[isolate->main] $data');
      }
    });

    await Isolate.spawn(_serverIsolate, [isolateToMainStream.sendPort, server]);
    return completer.future as Future<SendPort>;
  }

  static void _serverIsolate(List<dynamic> args) {
    SendPort isolateToMainStream = args[0];
    DSUServer server = args[1];

    server.init();

    final mainToIsolateStream = ReceivePort();
    isolateToMainStream.send(mainToIsolateStream.sendPort);

    mainToIsolateStream.listen((data) {
      if (data is Device) {
        server.registerDevice(data);
      } else if (data is ChangeSlotEvent) {
        server.changeSlot(data);
      } else if (data is GyroEvent) {
        server.slots[data.slot]?.setGyro(data);
      } else if (data is AccEvent) {
        server.slots[data.slot]?.setAcc(data);
      } else if (data is MultiButtonEvent) {
        server.slots[data.slot]?.setStates(data.value);
        debugPrint(
          '${DateTime.now().millisecondsSinceEpoch} [main->isolate] value: ${data.value}',
        );
      } else if (data is ButtonEvent) {
        server.slots[data.slot]?.setState(data.btnType, data.value);
        debugPrint(
          '${DateTime.now().millisecondsSinceEpoch} [main->isolate] pressed ${data.btnType}, value: ${data.value}',
        );
      } else {
        print('${DateTime.now().millisecondsSinceEpoch} [main->isolate] $data');
      }
    });
  }
}
