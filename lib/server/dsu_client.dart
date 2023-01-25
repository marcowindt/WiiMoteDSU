import 'dart:io';

class DsuClient {
  InternetAddress address;
  int port;

  DsuClient(this.address, this.port);

  @override
  bool operator ==(Object other) =>
      other is DsuClient && other.address == address && other.port == port;

  @override
  int get hashCode => address.hashCode + port;
}
