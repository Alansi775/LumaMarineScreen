import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/can_protocol.dart';
import '../../../core/canbus/node_connection.dart';
import '../domain/big_relay_channel.dart';

part 'big_relay_controller.g.dart';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
/// Every action is rejected outright when no node is connected, exactly
/// like the real firmware's "NODE NOT CONNECTED" status — including
/// Auto Pair, which on the real device visibly refuses to toggle.
@riverpod
class BigRelayController extends _$BigRelayController {
  @override
  BigRelayState build() {
    return BigRelayState(
      channels: [
        for (var i = 0; i < CanProtocol.bigRelayChannelCount; i++) BigRelayChannel(index: i),
      ],
    );
  }

  bool _rejectIfDisconnected() {
    if (NodeConnection.bigRelayNodeConnected) return false;
    // ignore: avoid_print
    print('[CANBUS] REJECTED — Big relay node not connected');
    return true;
  }

  void toggleOutput(int index) {
    if (_rejectIfDisconnected()) return;

    final newOn = !state.channels[index].outputOn;
    state = state.copyWith(channels: [
      for (final c in state.channels)
        if (c.index == index) c.copyWith(outputOn: newOn) else c,
    ]);
    ref.read(canBusServiceProvider).setBigRelayOutput(channel: index + 1, isOn: newOn);
  }

  void setAllOutputs(bool on) {
    if (_rejectIfDisconnected()) return;

    state = state.copyWith(channels: [for (final c in state.channels) c.copyWith(outputOn: on)]);
    ref.read(canBusServiceProvider).setAllBigRelayOutputs(isOn: on);
  }

  void setAutoPair(bool enabled) {
    if (_rejectIfDisconnected()) return;

    state = state.copyWith(autoPairEnabled: enabled);
    ref.read(canBusServiceProvider).setBigRelayAutoPair(enabled: enabled);
  }
}
