import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../domain/door_model.dart';

part 'doors_controller.g.dart';

/// Relay channel each door's release solenoid is wired to, on the extra
/// relay node (channel 1 there is the TV socket — see TvController).
/// RELAY_CMD_SET, usrSocketsPage.c.
const _doorRelayChannels = {'main': 2, 'aft': 3};

/// Two monitored doors. [trigger] opens a door and automatically closes it
/// again one second later — a real release pulse, not a sticky toggle.
@riverpod
class DoorsController extends _$DoorsController {
  final Map<String, Timer> _closeTimers = {};

  @override
  List<Door> build() {
    ref.onDispose(() {
      for (final timer in _closeTimers.values) {
        timer.cancel();
      }
    });
    return const [
      Door(id: 'main', name: 'Main Door', icon: Icons.sensor_door_outlined),
      Door(id: 'aft', name: 'Aft Door', icon: Icons.meeting_room_outlined),
    ];
  }

  void trigger(String id) {
    _closeTimers[id]?.cancel();

    state = [
      for (final door in state)
        if (door.id == id) door.copyWith(isOpen: true) else door,
    ];

    final channel = _doorRelayChannels[id];
    if (channel != null) {
      ref.read(canBusServiceProvider).setExtraRelay(channel: channel, isOn: true);
    }

    _closeTimers[id] = Timer(const Duration(seconds: 1), () {
      state = [
        for (final door in state)
          if (door.id == id) door.copyWith(isOpen: false) else door,
      ];
      if (channel != null) {
        ref.read(canBusServiceProvider).setExtraRelay(channel: channel, isOn: false);
      }
    });
  }
}
