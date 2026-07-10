import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../domain/socket_model.dart';

part 'sockets_controller.g.dart';

/// Fixed 6-channel relay bank — matches the ESP32 Sockets Control page
/// (RELAY_CMD_SET, usrSocketsPage.c) exactly, including the channel count.
@riverpod
class SocketsController extends _$SocketsController {
  @override
  List<SocketModel> build() {
    return const [
      SocketModel(id: 's1', name: 'Bow Outlet', isOn: false),
      SocketModel(id: 's2', name: 'Stern Outlet', isOn: false),
      SocketModel(id: 's3', name: 'Galley Outlet', isOn: true),
      SocketModel(id: 's4', name: 'Cabin Outlet', isOn: false),
      SocketModel(id: 's5', name: 'Cockpit Outlet', isOn: false),
      SocketModel(id: 's6', name: 'Flybridge Outlet', isOn: false),
    ];
  }

  void toggle(String id) {
    final index = state.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final newIsOn = !state[index].isOn;
    state = [
      for (final socket in state)
        if (socket.id == id) socket.copyWith(isOn: newIsOn) else socket,
    ];

    ref.read(canBusServiceProvider).setSocketRelay(channel: index + 1, isOn: newIsOn);
  }

  void allOff() {
    state = [for (final s in state) s.copyWith(isOn: false)];
    for (var i = 0; i < state.length; i++) {
      ref.read(canBusServiceProvider).setSocketRelay(channel: i + 1, isOn: false);
    }
  }
}
