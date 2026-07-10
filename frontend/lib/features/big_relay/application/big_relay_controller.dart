import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/can_protocol.dart';
import '../domain/big_relay_channel.dart';

part 'big_relay_controller.g.dart';

/// 16-channel relay bank with real I/O feedback (usrBigRelayPage.h/.c).
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

  void toggleOutput(int index) {
    final newOn = !state.channels[index].outputOn;
    state = state.copyWith(channels: [
      for (final c in state.channels)
        if (c.index == index) c.copyWith(outputOn: newOn) else c,
    ]);
    ref.read(canBusServiceProvider).setBigRelayOutput(channel: index + 1, isOn: newOn);
  }

  void setAllOutputs(bool on) {
    state = state.copyWith(channels: [for (final c in state.channels) c.copyWith(outputOn: on)]);
    ref.read(canBusServiceProvider).setAllBigRelayOutputs(isOn: on);
  }

  void setAutoPair(bool enabled) {
    state = state.copyWith(autoPairEnabled: enabled);
    ref.read(canBusServiceProvider).setBigRelayAutoPair(enabled: enabled);
  }
}
