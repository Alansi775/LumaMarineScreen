import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';

part 'tv_controller.g.dart';

/// Single on/off toggle for the saloon TV — wired to the extra relay node
/// (RELAY_CMD_SET, see usrSocketsPage.c), channel 1.
@riverpod
class TvController extends _$TvController {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
    ref.read(canBusServiceProvider).setExtraRelay(channel: 1, isOn: state);
  }
}
