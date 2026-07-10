import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'can_bus_transport.dart';
import 'can_frame.dart';
import 'can_protocol.dart';
import 'logging_can_bus_transport.dart';

part 'can_bus_service.g.dart';

@riverpod
CanBusTransport canBusTransport(CanBusTransportRef ref) =>
    LoggingCanBusTransport();

@riverpod
CanBusService canBusService(CanBusServiceRef ref) {
  return CanBusService(ref.watch(canBusTransportProvider));
}

/// Builds and sends the exact frames the ESP32 LED/Relay nodes expect.
/// One method per real-world action — callers don't touch byte layout.
class CanBusService {
  CanBusService(this._transport);

  final CanBusTransport _transport;

  /// LED_CMD_SET (0x11): [cmd, channel(1-based), state]
  Future<void> setLed({required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.ledNodeId,
      data: [CanProtocol.ledCmdSet, channel, isOn ? 1 : 0],
    ));
  }

  /// LED_CMD_SET_BRIGHTNESS (0x12): [cmd, channel, value>>8, value&0xFF]
  Future<void> setLedBrightness({required int channel, required int value}) {
    return _transport.send(CanFrame(
      id: CanProtocol.ledNodeId,
      data: [
        CanProtocol.ledCmdSetBrightness,
        channel,
        (value >> 8) & 0xFF,
        value & 0xFF,
      ],
    ));
  }

  /// RELAY_CMD_SET (0x21): [cmd, channel(1-based), state]
  Future<void> setRelay({required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.relayNodeId,
      data: [CanProtocol.relayCmdSet, channel, isOn ? 1 : 0],
    ));
  }
}
