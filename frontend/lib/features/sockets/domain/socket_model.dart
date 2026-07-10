/// A single relay-controlled power socket. Fixed 6-channel layout,
/// mirroring the ESP32 reference project's Sockets Control page.
class SocketModel {
  const SocketModel({
    required this.id,
    required this.name,
    required this.isOn,
  });

  final String id;
  final String name;
  final bool isOn;

  SocketModel copyWith({bool? isOn}) {
    return SocketModel(id: id, name: name, isOn: isOn ?? this.isOn);
  }
}
