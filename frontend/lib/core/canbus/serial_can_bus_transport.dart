import 'can_bus_transport.dart';
import 'serial_can_bus_transport_stub.dart'
    if (dart.library.io) 'serial_can_bus_transport_io.dart' as impl;

/// Talks to the real Waveshare RS232/422-to-CAN converter wired to the
/// kiosk's COM2 (`/dev/ttyS1`) — this is the transport that actually
/// reaches physical hardware, unlike [LoggingCanBusTransport] which only
/// prints. Conditionally exported: the real `dart:io`-based
/// implementation compiles only where `dart:io` exists (the embedded
/// Linux kiosk); a no-op stub that just logs takes over automatically
/// when running on web (e.g. `flutter run -d chrome` for quick UI
/// iteration on a dev machine, which has no serial port to open and
/// can't use `dart:io` at all).
///
/// CAVEAT — the exact byte envelope this specific Waveshare model
/// expects for a CAN frame is not yet confirmed against its datasheet;
/// see the real implementation's docs for what's actually sent today.
abstract class SerialCanBusTransport implements CanBusTransport {
  factory SerialCanBusTransport({String devicePath = '/dev/ttyS1', int baudRate = 115200}) =>
      impl.createSerialCanBusTransport(devicePath: devicePath, baudRate: baudRate);

  Future<void> open();
  Future<void> dispose();
}
