import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../domain/toilet_channel.dart';

part 'toilet_controller.g.dart';

/// 6-channel PWM pump control (usrToiletPage.c). Channel index is 0-based
/// and added directly to the fixed base CAN IDs — no dynamic node lookup.
@riverpod
class ToiletController extends _$ToiletController {
  @override
  List<ToiletChannel> build() {
    return const [
      ToiletChannel(id: 'fwd', name: 'Forward Head'),
      ToiletChannel(id: 'aft', name: 'Aft Head'),
      ToiletChannel(id: 'master', name: 'Master Head'),
      ToiletChannel(id: 'crew', name: 'Crew Head'),
      ToiletChannel(id: 'day', name: 'Day Head'),
      ToiletChannel(id: 'utility', name: 'Utility Pump'),
    ];
  }

  void toggle(String id) {
    final index = state.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final newIsOn = !state[index].isOn;
    final pwm = newIsOn ? (state[index].pwmValue == 0 ? 1000 : state[index].pwmValue) : 0;

    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(isOn: newIsOn, pwmValue: pwm) else c,
    ];

    ref.read(canBusServiceProvider).setToiletButton(channel: index, isOn: newIsOn);
    if (newIsOn) {
      ref.read(canBusServiceProvider).setToiletSlider(channel: index, value: pwm);
    }
  }

  void setPwm(String id, int value) {
    final index = state.indexWhere((c) => c.id == id);
    if (index == -1) return;

    state = [
      for (final c in state)
        if (c.id == id) c.copyWith(pwmValue: value, isOn: value > 0) else c,
    ];

    ref.read(canBusServiceProvider).setToiletSlider(channel: index, value: value);
  }
}
