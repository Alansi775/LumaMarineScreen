import 'dart:async';

import 'can_bus_transport.dart';
import 'can_frame.dart';

/// Prints every outgoing frame to the terminal/log — this is how we test
/// the protocol before real CAN hardware is wired up on the device.
/// One line per press, same shape as the ESP32/STM32 side's own TX log.
///
/// `incoming` never emits here — there's no real bus attached, so
/// nothing (e.g. a board's dynamic-ID request) will ever arrive. Once a
/// real serial/SocketCAN transport exists, swapping the provider in
/// `can_bus_service.dart` is the only change needed — everything built
/// against [CanBusTransport] (including the ID-assignment master)
/// already expects this shape.
class LoggingCanBusTransport implements CanBusTransport {
  final _incoming = StreamController<CanFrame>.broadcast();

  @override
  Future<void> send(CanFrame frame) async {
    // ignore: avoid_print
    print('[CANBUS] ${frame.toLogString()}');
  }

  @override
  Stream<CanFrame> get incoming => _incoming.stream;
}
