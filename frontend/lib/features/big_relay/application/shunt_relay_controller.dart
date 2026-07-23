import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/node_connection.dart';

part 'shunt_relay_controller.g.dart';

/// The Big Shunt card's 2 relay outputs (BIG_SHUNT_CMD_SET_RELAY,
/// usrShuntPage.h) — index 0 = relay 1, index 1 = relay 2. Snaps back
/// after [NodeConnection.revertDelay] since no shunt node is connected.
@riverpod
class ShuntRelayController extends _$ShuntRelayController {
  final Map<int, Timer> _revertTimers = {};

  @override
  List<bool> build() {
    ref.onDispose(() {
      for (final timer in _revertTimers.values) {
        timer.cancel();
      }
    });
    return [false, false];
  }

  void toggle(int index) {
    final newOn = !state[index];
    state = [for (var i = 0; i < state.length; i++) i == index ? newOn : state[i]];
    ref.read(canBusServiceProvider).setShuntRelay(relay: index + 1, isOn: newOn);

    // Always settles back to OFF — see LightsController.toggle for why
    // reverting to a per-press "previous" value is wrong.
    _revertTimers[index]?.cancel();
    if (!NodeConnection.bigShuntNodeConnected && newOn) {
      _revertTimers[index] = Timer(NodeConnection.revertDelay, () {
        state = [for (var i = 0; i < state.length; i++) i == index ? false : state[i]];
      });
    }
  }
}
