import 'can_frame.dart';

/// How [CanFrame]s actually reach the bus. Phase 1 only has
/// [LoggingCanBusTransport] (no hardware attached yet) — swapping in a real
/// SocketCAN transport later is a single provider override, no UI change.
abstract class CanBusTransport {
  Future<void> send(CanFrame frame);
}
