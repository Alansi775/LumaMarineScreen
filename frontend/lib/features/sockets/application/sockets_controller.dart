import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/node_connection.dart';
import '../domain/socket_model.dart';

part 'sockets_controller.g.dart';

/// Fixed 6-channel relay bank — matches the ESP32 Sockets Control page
/// (RELAY_CMD_SET, usrSocketsPage.c) exactly, including the channel count
/// and default "PWM-1".."PWM-6" names (`button_names[2]` in
/// usrSettingsPage.c) before a user renames them via Settings.
@riverpod
class SocketsController extends _$SocketsController {
  final Map<String, Timer> _revertTimers = {};

  @override
  List<SocketModel> build() {
    ref.onDispose(() {
      for (final timer in _revertTimers.values) {
        timer.cancel();
      }
    });
    return const [
      SocketModel(id: 's1', name: 'PWM-1', isOn: false),
      SocketModel(id: 's2', name: 'PWM-2', isOn: false),
      SocketModel(id: 's3', name: 'PWM-3', isOn: true),
      SocketModel(id: 's4', name: 'PWM-4', isOn: false),
      SocketModel(id: 's5', name: 'PWM-5', isOn: false),
      SocketModel(id: 's6', name: 'PWM-6', isOn: false),
    ];
  }

  /// Responds immediately, but snaps back after [NodeConnection.revertDelay]
  /// since no relay node is connected to confirm the change.
  void toggle(String id) {
    final index = state.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final previousIsOn = state[index].isOn;
    final newIsOn = !previousIsOn;
    state = [
      for (final socket in state)
        if (socket.id == id) socket.copyWith(isOn: newIsOn) else socket,
    ];

    ref.read(canBusServiceProvider).setSocketRelay(channel: index + 1, isOn: newIsOn);

    _revertTimers[id]?.cancel();
    if (!NodeConnection.socketsRelayNodeConnected) {
      _revertTimers[id] = Timer(NodeConnection.revertDelay, () {
        state = [
          for (final socket in state)
            if (socket.id == id) socket.copyWith(isOn: previousIsOn) else socket,
        ];
      });
    }
  }

  void allOff() {
    for (final timer in _revertTimers.values) {
      timer.cancel();
    }
    _revertTimers.clear();

    state = [for (final s in state) s.copyWith(isOn: false)];
    for (var i = 0; i < state.length; i++) {
      ref.read(canBusServiceProvider).setSocketRelay(channel: i + 1, isOn: false);
    }
  }
}
