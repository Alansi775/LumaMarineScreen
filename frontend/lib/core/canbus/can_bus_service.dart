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

/// Builds and sends the exact frames each ESP32 node type expects. One
/// method per real-world action — callers don't touch byte layout.
class CanBusService {
  CanBusService(this._transport);

  final CanBusTransport _transport;

  /// LED_CMD_SET (0x11): [cmd, channel(1-based), state]. [nodeId] is the
  /// LED board's *dynamically assigned* CAN ID (see [CanIdMaster]) —
  /// there's no fixed ID for real LED boards, they get one at boot via
  /// the request/assign handshake. Pass [CanProtocol.canBroadcastId] if
  /// no assignment is known yet (ignored by the board until it's ACTIVE).
  Future<void> setLed({required int nodeId, required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: nodeId,
      data: [CanProtocol.ledCmdSet, channel, isOn ? 1 : 0],
    ));
  }

  /// LED_CMD_SET_BRIGHTNESS (0x12): [cmd, channel, value>>8, value&0xFF]
  Future<void> setLedBrightness({required int nodeId, required int channel, required int value}) {
    return _transport.send(CanFrame(
      id: nodeId,
      data: [
        CanProtocol.ledCmdSetBrightness,
        channel,
        (value >> 8) & 0xFF,
        value & 0xFF,
      ],
    ));
  }

  /// RELAY_CMD_SET (0x21) to the Sockets Control node (matches their
  /// 6-channel Sockets page 1:1).
  Future<void> setSocketRelay({required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.socketsRelayNodeId,
      data: [CanProtocol.relayCmdSet, channel, isOn ? 1 : 0],
    ));
  }

  /// RELAY_CMD_SET (0x21) to our own extra relay outputs (TV, Doors) —
  /// not part of their 6-channel Sockets spec, kept on a separate node id
  /// so channel numbers don't collide with it.
  Future<void> setExtraRelay({required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.extraRelayNodeId,
      data: [CanProtocol.relayCmdSet, channel, isOn ? 1 : 0],
    ));
  }

  /// BIG_RELAY_CMD_SET_OUTPUT (0x30): [cmd, channel(1-based), state]
  Future<void> setBigRelayOutput({required int channel, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.bigRelayNodeId,
      data: [CanProtocol.bigRelayCmdSetOutput, channel, isOn ? 1 : 0],
    ));
  }

  /// BIG_RELAY_CMD_SET_ALL (0x32): [cmd, state]
  Future<void> setAllBigRelayOutputs({required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.bigRelayNodeId,
      data: [CanProtocol.bigRelayCmdSetAll, isOn ? 1 : 0],
    ));
  }

  /// BIG_RELAY_CMD_SET_AUTO_PAIR (0x34): [cmd, enabled]
  Future<void> setBigRelayAutoPair({required bool enabled}) {
    return _transport.send(CanFrame(
      id: CanProtocol.bigRelayNodeId,
      data: [CanProtocol.bigRelayCmdSetAutoPair, enabled ? 1 : 0],
    ));
  }

  /// BIG_SHUNT_CMD_SET_RELAY (0x43): [cmd, relay(1-2), state]
  Future<void> setShuntRelay({required int relay, required bool isOn}) {
    return _transport.send(CanFrame(
      id: CanProtocol.bigShuntNodeId,
      data: [CanProtocol.bigShuntCmdSetRelay, relay, isOn ? 1 : 0],
    ));
  }

}
