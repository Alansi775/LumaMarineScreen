import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';

part 'shunt_relay_controller.g.dart';

/// The Big Shunt card's 2 relay outputs (BIG_SHUNT_CMD_SET_RELAY,
/// usrShuntPage.h) — index 0 = relay 1, index 1 = relay 2. Toggles and
/// stays — [NodeStatusPill] is the honest signal about whether hardware
/// is actually there, not a state that reverts itself.
@riverpod
class ShuntRelayController extends _$ShuntRelayController {
  @override
  List<bool> build() {
    return [false, false];
  }

  void toggle(int index) {
    final newOn = !state[index];
    state = [for (var i = 0; i < state.length; i++) i == index ? newOn : state[i]];
    ref.read(canBusServiceProvider).setShuntRelay(relay: index + 1, isOn: newOn);
  }
}
