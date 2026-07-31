import 'can_frame.dart';

/// How [CanFrame]s actually reach the bus. Phase 1 only has
/// [LoggingCanBusTransport] (no hardware attached yet) — swapping in a real
/// serial/SocketCAN transport later is a single provider override, no UI
/// change. `incoming` exists so a bus master (dynamic CAN ID assignment,
/// see `can_id_master.dart`) can react to frames from real nodes — a
/// logging-only transport just never emits on it.
abstract class CanBusTransport {
  Future<void> send(CanFrame frame);

  Stream<CanFrame> get incoming;
}
