import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/node_connection.dart';
import '../domain/light_model.dart';

part 'lights_controller.g.dart';

/// In-memory light registry. Fully user-managed: toggle on/off, add new
/// named lights. Persistence across app restarts plugs in here later by
/// swapping [build]'s seed + adding a save-on-mutation call — no UI change.
/// The first 6 channels default to "PWM-1".."PWM-6" — the exact default
/// names the ESP32 firmware ships with (`button_names[1]` in
/// usrSettingsPage.c) before a user renames them via Settings.
@riverpod
class LightsController extends _$LightsController {
  @override
  List<Light> build() {
    return const [
      Light(id: 'ch1', name: 'PWM-1', icon: Icons.lightbulb_outline, isOn: true),
      Light(id: 'ch2', name: 'PWM-2', icon: Icons.lightbulb_outline, isOn: false),
      Light(id: 'ch3', name: 'PWM-3', icon: Icons.lightbulb_outline, isOn: false),
      Light(id: 'ch4', name: 'PWM-4', icon: Icons.lightbulb_outline, isOn: true),
      Light(id: 'ch5', name: 'PWM-5', icon: Icons.lightbulb_outline, isOn: false),
      Light(id: 'ch6', name: 'PWM-6', icon: Icons.lightbulb_outline, isOn: false),
    ];
  }

  /// Channel = 1-based position in the list — mirrors the ESP32 LED card's
  /// fixed 6-channel layout (LED_CMD_SET, see usrLightingPage.c). Rejected
  /// outright when no LED node is connected, exactly like their firmware
  /// (`if (led_node_id == 0) { ...; return; }`) — no state change, no CAN
  /// frame, just the same "LED kartı bağlı değil" rejection.
  void toggle(String id) {
    if (!NodeConnection.ledNodeConnected) {
      // ignore: avoid_print
      print('[CANBUS] REJECTED — LED kartı bağlı değil (LED node not connected)');
      return;
    }

    final index = state.indexWhere((light) => light.id == id);
    if (index == -1) return;

    final newIsOn = !state[index].isOn;
    state = [
      for (final light in state)
        if (light.id == id) light.copyWith(isOn: newIsOn) else light,
    ];

    if (index < 6) {
      ref.read(canBusServiceProvider).setLed(channel: index + 1, isOn: newIsOn);
    }
  }

  void addLight({required String name, required IconData icon}) {
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    state = [...state, Light(id: id, name: name, icon: icon, isOn: false)];
  }

  /// Matches the real ESP32 Lighting page's "Close All" button.
  void closeAll() {
    if (!NodeConnection.ledNodeConnected) {
      // ignore: avoid_print
      print('[CANBUS] REJECTED — LED kartı bağlı değil (LED node not connected)');
      return;
    }

    state = [for (final light in state) light.copyWith(isOn: false)];
    for (var i = 0; i < state.length && i < 6; i++) {
      ref.read(canBusServiceProvider).setLed(channel: i + 1, isOn: false);
    }
  }
}
