import 'dart:typed_data';
import 'package:crclib/crclib.dart';

class Message {

  static Uint8List TYPE_VERSION = Uint8List.fromList([0x00, 0x00, 0x10, 0x00]);
  static Uint8List TYPE_PORTS = Uint8List.fromList([0x01, 0x00, 0x10, 0x00]);
  static Uint8List TYPE_DATA = Uint8List.fromList([0x02, 0x00, 0x10, 0x00]);

  make(Uint8List type, Uint8List data) {

    Uint8List packet = Uint8List.fromList([
      0x44, 0x53, 0x55, 0x53,           // DSUS
      0xE9, 0x03,                       // Protocol version (1001)
      ((data.length + 4) & 0xFF),       // Data length (Little endian)
      ((data.length + 4) >> 8) & 0xFF,  // Data length
      0x00, 0x00, 0x00, 0x00,           // CRC32 initially empty
      0xEF, 0xEF, 0xEF, 0xEF,           // Server ID
      ...type,                          // type
      ...data,                          // data
    ]); //

    var crc = new Crc32Zlib().convert(packet) & 0xFFFFFFFF;
    packet.setRange(8, 9, [(crc) & 0xFF]);
    packet.setRange(9, 10, [(crc >> 8) & 0xFF]);
    packet.setRange(10, 11, [(crc >> 16) & 0xFF]);
    packet.setRange(11, 12, [(crc >> 24) & 0xFF]);

    return packet;
  }

}
