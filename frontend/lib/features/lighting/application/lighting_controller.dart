// lib/features/lighting/application/lighting_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/canbus/can_bus_service.dart';
import '../../../core/canbus/can_id_master.dart';
import '../../../core/canbus/can_protocol.dart';
import '../domain/light_channel.dart';

part 'lighting_controller.g.dart';

/// AYDINLATMA SİSTEMİ — the 4 physically-wired LED channels (led# 1-4 on
/// the real board; 5-6 are unused on this yacht). Every toggle/dimmer
/// change sends the exact frame the STM32 LED board firmware expects
/// (LED_CMD_SET / LED_CMD_SET_BRIGHTNESS), addressed to whatever CAN ID
/// [CanIdMaster] has dynamically assigned that board — never a fixed ID,
/// since the real board doesn't have one until the handshake completes.
@riverpod
class LightingController extends _$LightingController {
  @override
  List<LightChannel> build() {
    return const [
      LightChannel(ledNumber: 1, name: 'FLOOR 1'),
      LightChannel(ledNumber: 2, name: 'FLOOR 2'),
      LightChannel(ledNumber: 3, name: 'FLOOR 3'),
      LightChannel(ledNumber: 4, name: 'WATER LIGHT'),
    ];
  }

  int _targetNodeId() {
    final node = ref.read(canIdMasterProvider).nodeFor(CanProtocol.nodeTypeLed);
    return (node != null && node.active) ? node.assignedId : CanProtocol.ledNodeId;
  }

  void toggle(int ledNumber) async {
    final index = state.indexWhere((c) => c.ledNumber == ledNumber);
    if (index == -1) return;

    final currentChannel = state[index];
    final newOn = !currentChannel.isOn;

    state = [
      for (final c in state)
        if (c.ledNumber == ledNumber) c.copyWith(isOn: newOn) else c,
    ];

    final targetId = _targetNodeId();
    if (newOn) {
      ref.read(canBusServiceProvider).setLed(
        nodeId: targetId,
        channel: ledNumber,
        isOn: true,
      );

      await Future.delayed(const Duration(milliseconds: 10));

      ref.read(canBusServiceProvider).setLedBrightness(
        nodeId: targetId,
        channel: ledNumber,
        value: currentChannel.brightness,
      );
    } else {
      ref.read(canBusServiceProvider).setLed(
        nodeId: targetId,
        channel: ledNumber,
        isOn: false,
      );
    }
  }

  void setBrightness(int ledNumber, int value) {
    final index = state.indexWhere((c) => c.ledNumber == ledNumber);
    if (index == -1) return;

    final isCurrentlyOn = state[index].isOn;

    state = [
      for (final c in state)
        if (c.ledNumber == ledNumber) c.copyWith(brightness: value) else c,
    ];

    // نرسل للبوردة فقط إذا كانت القناة مضاءة حالياً
    if (isCurrentlyOn) {
      ref.read(canBusServiceProvider).setLedBrightness(
        nodeId: _targetNodeId(),
        channel: ledNumber,
        value: value,
      );
    }
  }

  void rename(int ledNumber, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = [
      for (final c in state)
        if (c.ledNumber == ledNumber) c.copyWith(name: trimmed.toUpperCase()) else c,
    ];
  }
}

/// Reactive LED board connection status for the screen's status pill —
/// null/inactive until the real board completes the ID handshake.
@riverpod
Stream<AssignedCanNode?> ledNodeAssignment(LedNodeAssignmentRef ref) async* {
  final master = ref.watch(canIdMasterProvider);
  yield master.nodeFor(CanProtocol.nodeTypeLed);
  yield* master.updates.where((n) => n.nodeType == CanProtocol.nodeTypeLed);
}
