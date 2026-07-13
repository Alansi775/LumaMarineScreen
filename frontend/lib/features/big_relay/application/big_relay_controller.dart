import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/can_protocol.dart';
import '../../../core/canbus/node_connection.dart';
import '../domain/big_relay_channel.dart';

part 'big_relay_controller.g.dart';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
/// Every action responds immediately (so the app demos smoothly) but
/// snaps back after [NodeConnection.revertDelay] since no node is
/// connected to actually confirm it — including Auto Pair.
@riverpod
class BigRelayController extends _$BigRelayController {
  final Map<int, Timer> _outputRevertTimers = {};
  Timer? _autoPairRevertTimer;

  @override
  BigRelayState build() {
    ref.onDispose(() {
      for (final timer in _outputRevertTimers.values) {
        timer.cancel();
      }
      _autoPairRevertTimer?.cancel();
    });
    return BigRelayState(
      channels: [
        for (var i = 0; i < CanProtocol.bigRelayChannelCount; i++) BigRelayChannel(index: i),
      ],
    );
  }

  void toggleOutput(int index) {
    final previousOn = state.channels[index].outputOn;
    final newOn = !previousOn;
    state = state.copyWith(channels: [
      for (final c in state.channels)
        if (c.index == index) c.copyWith(outputOn: newOn) else c,
    ]);
    ref.read(canBusServiceProvider).setBigRelayOutput(channel: index + 1, isOn: newOn);

    _outputRevertTimers[index]?.cancel();
    if (!NodeConnection.bigRelayNodeConnected) {
      _outputRevertTimers[index] = Timer(NodeConnection.revertDelay, () {
        state = state.copyWith(channels: [
          for (final c in state.channels)
            if (c.index == index) c.copyWith(outputOn: previousOn) else c,
        ]);
      });
    }
  }

  void setAllOutputs(bool on) {
    for (final timer in _outputRevertTimers.values) {
      timer.cancel();
    }
    _outputRevertTimers.clear();

    state = state.copyWith(channels: [for (final c in state.channels) c.copyWith(outputOn: on)]);
    ref.read(canBusServiceProvider).setAllBigRelayOutputs(isOn: on);
  }

  void setAutoPair(bool enabled) {
    final previous = state.autoPairEnabled;
    state = state.copyWith(autoPairEnabled: enabled);
    ref.read(canBusServiceProvider).setBigRelayAutoPair(enabled: enabled);

    _autoPairRevertTimer?.cancel();
    if (!NodeConnection.bigRelayNodeConnected) {
      _autoPairRevertTimer = Timer(NodeConnection.revertDelay, () {
        state = state.copyWith(autoPairEnabled: previous);
      });
    }
  }
}
