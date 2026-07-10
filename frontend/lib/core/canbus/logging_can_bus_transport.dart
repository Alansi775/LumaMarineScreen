import 'can_bus_transport.dart';
import 'can_frame.dart';

/// Prints every outgoing frame to the terminal/log — this is how we test
/// the protocol before real CAN hardware (SocketCAN) is wired up on the
/// device. One line per press, same shape as the ESP32's own TX log.
class LoggingCanBusTransport implements CanBusTransport {
  @override
  Future<void> send(CanFrame frame) async {
    // ignore: avoid_print
    print('[CANBUS] ${frame.toLogString()}');
  }
}
