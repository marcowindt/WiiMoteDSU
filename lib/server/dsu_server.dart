import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:udp/udp.dart';
import 'package:wiimote_dsu/devices/device.dart';

import 'message.dart';

class DSUServer {
  var timeOut = 20; // seconds
  var portNum = 26760;
  var counter = 0;
  Map<InternetAddress, int> clients = new Map();
  List<Device> slots = [null, null, null, null];
  UDP socket;

  DSUServer({this.portNum = 26760});

  init() async {
    printSlots();
    UDP
        .bind(Endpoint.unicast(InternetAddress.anyIPv4, port: Port(portNum)))
        .then((sock) {
      socket = sock;
      this.start();
    });
  }

  incoming(Datagram datagram) {
    Uint8List message = datagram.data;
    InternetAddress address = datagram.address;
    int port = datagram.port;
    Uint8List type = message.sublist(16, 20);

    Function eq = const ListEquality().equals;

    if (eq(type, Message.TYPE_VERSION)) {
      return; // ignore
    } else if (eq(type, Message.TYPE_PORTS)) {
      this.incomingPortRequest(message, address, port);
    } else if (eq(type, Message.TYPE_DATA)) {
      this.incomingDataRequest(message, address, port);
    } else {
      print("[udp] Unknown message type: " + (type.toString()));
    }
  }

  incomingPortRequest(
      Uint8List message, InternetAddress address, int port) async {
    var requestsCount = message.sublist(20, 24)[0];

    for (var i = 0; i < requestsCount; i++) {
      Uint8List ports = this.sendPorts(i);
      socket
          .send(ports, Endpoint.unicast(address, port: Port(port)))
          .then((value) {});
    }
  }

  incomingDataRequest(
      Uint8List message, InternetAddress address, int port) async {
    var flags = message[24];
    var regId = message[25];

    if (flags == 0 && regId == 0) {
      if (!clients.containsKey(address)) {
        print("[udp] Client connected: " +
            address.toString() +
            " on port " +
            port.toString());
      }

      clients[address] = port;

      this.report(slots[0]);
    }
  }

  absToButton(value) {
    if (value > 0.75 * 255) {
      return 255;
    }
    return 0;
  }

  sendPorts(int index) {
    if (slots[index] != null) {
      Device device = slots[index];
      Uint8List data = Uint8List.fromList([
        index, // pad id
        0x02, // state (connected)
        device.model, // model (generic)
        0x01, // Connection type USB
        device.mac[0], device.mac[1], device.mac[2], // Mac part 1
        device.mac[3], device.mac[4], device.mac[5], // Mac part 2
        0x05, // Battery (full)
        0x00, // ? (Needs to be a zero byte according to specs)
      ]);

      var message = new Message().make(Message.TYPE_PORTS, data);
      return message;
    } else {
      Uint8List data = Uint8List.fromList([
        index, // pad id
        0x00, // state (disconnected)
        0x01, // model (generic)
        0x01, // Connection type USB
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Mac
        0x00, // Battery
        0x00, // ? (Needs to be a zero byte according to specs)
      ]);

      return new Message().make(Message.TYPE_PORTS, data);
    }
  }

  report(Device device) {
    if (device == null || device.disconnected) {
      return;
    }

    var i = slots.indexOf(device);
    if (i == -1) {
      return;
    }

    var deviceState = device.getReport();

    var buttons1 = 0x00;
    buttons1 |= (deviceState["button_share"] / 255).round();
    buttons1 |= (deviceState["button_l3"] / 255).round() << 1;
    buttons1 |= (deviceState["button_r3"] / 255).round() << 2;
    buttons1 |= (deviceState["button_options"] / 255).round() << 3;
    buttons1 |= (deviceState["dpad_up"] / 255).round() << 4;
    buttons1 |= (deviceState["dpad_right"] / 255).round() << 5;
    buttons1 |= (deviceState["dpad_down"] / 255).round() << 6;
    buttons1 |= (deviceState["dpad_left"] / 255).round() << 7;

    var buttons2 = 0x00;
    buttons2 |= (deviceState["button_l2"] / 255).round();
    buttons2 |= (deviceState["button_r2"] / 255).round() << 1;
    buttons2 |= (deviceState["button_l1"] / 255).round() << 2;
    buttons2 |= (deviceState["button_r1"] / 255).round() << 3;
    buttons2 |= (deviceState["button_square"] / 255).round() << 4;
    buttons2 |= (deviceState["button_cross"] / 255).round() << 5;
    buttons2 |= (deviceState["button_circle"] / 255).round() << 6;
    buttons2 |= (deviceState["button_triangle"] / 255).round() << 7;

    var time = new DateTime.now().microsecondsSinceEpoch;

    var bdAccY = new ByteData(4);
    bdAccY.setFloat32(0, device.accY);
    var bdAccZ = new ByteData(4);
    bdAccZ.setFloat32(0, device.accZ);
    var bdAccX = new ByteData(4);
    bdAccX.setFloat32(0, device.accX);

    var bdMotionY = new ByteData(4);
    bdMotionY.setFloat32(0, device.motionY);
    var bdMotionZ = new ByteData(4);
    bdMotionZ.setFloat32(0, device.motionZ);
    var bdMotionX = new ByteData(4);
    bdMotionX.setFloat32(0, device.motionX);

    Uint8List data = Uint8List.fromList([
      i,
      0x02,
      device.model,
      0x02,
      device.mac[0], device.mac[1], device.mac[2], // Mac part 1
      device.mac[3], device.mac[4], device.mac[5], // Mac part 2
      deviceState["battery"], // Battery always full for now
      0x01, // Is active (true)
      counter & 0xFF,
      (counter >> 8) & 0xFF,
      (counter >> 16) & 0xFF,
      (counter >> 24) & 0xFF,

      buttons1,
      buttons2,
      (deviceState["button_ps"] * 127 + 128), // PS
      0x00, // Touch (unused)

      (deviceState["left_analog_x"] * 127 + 128), // position left x
      (deviceState["left_analog_y"] * 127 + 128), // position left y
      (deviceState["right_analog_x"] * 127 + 128), // position right x
      (deviceState["right_analog_x"] * 127 + 128), // position right y

      absToButton(deviceState["dpad_left"] * 127 + 128), // dpad left
      absToButton(deviceState["dpad_down"] * 127 + 128), // dpad down
      absToButton(deviceState["dpad_right"] * 127 + 128), // dpad right
      absToButton(deviceState["dpad_up"] * 127 + 128), // dpad up

      absToButton(deviceState["button_square"] * 127 + 128), // square
      absToButton(deviceState["button_cross"] * 127 + 128), // cross
      absToButton(deviceState["button_circle"] * 127 + 128), // circle
      absToButton(deviceState["button_triangle"] * 127 + 128), // triangle

      absToButton(deviceState["button_r1"] * 127 + 128), // r1
      absToButton(deviceState["button_l1"] * 127 + 128), // l1

      absToButton(deviceState["button_r2"] * 127 + 128), // r2
      absToButton(deviceState["button_l2"] * 127 + 128), // l2

      0x00, // track pad first is active (false)
      0x00, // track pad firs id

      0x00, 0x00, // track pad first x
      0x00, 0x00, // track pad first y

      0x00, // track pad second is active (false)
      0x00, // track pad second id

      0x00, 0x00, // track pad second x
      0x00, 0x00, // track pad second y

      time & 0xFF,
      (time >> 8) & 0xFF,
      (time >> 16) & 0xFF,
      (time >> 24) & 0xFF,
      (time >> 32) & 0xFF,
      (time >> 40) & 0xFF,
      (time >> 48) & 0xFF,
      (time >> 56) & 0xFF,

      bdAccX.getUint8(3), bdAccX.getUint8(2), bdAccX.getUint8(1),
      bdAccX.getUint8(0),
      bdAccY.getUint8(3), bdAccY.getUint8(2), bdAccY.getUint8(1),
      bdAccY.getUint8(0),
      bdAccZ.getUint8(3), bdAccZ.getUint8(2), bdAccZ.getUint8(1),
      bdAccZ.getUint8(0),
      bdMotionX.getUint8(3), bdMotionX.getUint8(2), bdMotionX.getUint8(1),
      bdMotionX.getUint8(0),
      bdMotionY.getUint8(3), bdMotionY.getUint8(2), bdMotionY.getUint8(1),
      bdMotionY.getUint8(0),
      bdMotionZ.getUint8(3), bdMotionZ.getUint8(2), bdMotionZ.getUint8(1),
      bdMotionZ.getUint8(0),
    ]);

    counter += 1;

    this.reportToClients(new Message().make(Message.TYPE_DATA, data));
  }

  reportClean(Device device) {
    var index = slots.indexOf(device);

    Uint8List data = Uint8List.fromList([
      index,
      0x00, // state disconnected
      0x02, // model (generic)
      0x01, // connection type (usb)
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // MAC
      0x00, // Battery (charged)
      0x00, // Zero byte from spec
    ]);

    this.reportToClients(new Message().make(Message.TYPE_DATA, data));
  }

  reportToClients(Uint8List message) {
    clients.forEach((address, port) {
      socket
          .send(message, Endpoint.unicast(address, port: Port(port)))
          .then((value) {});
    });
  }

  printSlots() {
    slots.forEach((device) {
      if (device != null) {
        print("Slot: " + device.deviceName);
      }
    });
  }

  start() async {
    print("Start listening for incoming datagrams on " +
        socket.local.address.toString() +
        " port " +
        socket.local.port.value.toString());

    socket.asStream().listen((datagram) {
      this.incoming(datagram);
    });

    await this.reportLoop(Duration(milliseconds: 1));
  }

  reportLoop(Duration interval) async {
    print("Report loop started");
    while (true) {
      slots.forEach((device) {
        if (device != null) {
          this.report(device);
        }
      });
      await Future.delayed(interval);
    }
  }

  void registerDevice(int slot, Device device) {
    this.slots[slot] = device;
    debugPrint("Registered device: Slot[$slot] ${device.deviceName}");
  }

  factory DSUServer.make({int portNum = 26760}) {
    return DSUServer(portNum: portNum);
  }
}
