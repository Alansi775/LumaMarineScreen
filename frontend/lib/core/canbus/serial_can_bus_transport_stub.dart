import 'can_frame.dart';
import 'serial_can_bus_transport.dart';

SerialCanBusTransport createSerialCanBusTransport({required String devicePath, required int baudRate}) {
  return _StubSerialCanBusTransport();
}

/// No `dart:io` on web — this stands in so the app still compiles and
/// runs there (useful for fast UI iteration via `flutter run -d
/// chrome`); it just can't reach real hardware from that target.
class _StubSerialCanBusTransport implements SerialCanBusTransport {
  @override
  Future<void> open() async {
    // ignore: avoid_print
    print('[SerialCanBus] stub transport (web/non-IO platform) — no real hardware I/O here.');
  }

  @override
  Future<void> send(CanFrame frame) async {
    // ignore: avoid_print
    print('[SerialCanBus:stub] ${frame.toLogString()}');
  }

  @override
  Stream<CanFrame> get incoming => const Stream.empty();

  @override
  Future<void> dispose() async {}
}
