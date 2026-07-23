import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/tank_model.dart';
import '../domain/tanks_state.dart';

part 'tanks_controller.g.dart';

/// Two rows of 3 generic tanks (T1-T3), one per resistive sensor type —
/// matches the real Tank Level page's row grouping, just 3 columns
/// instead of their 4. TEST_MODE toggle mirrors theirs exactly: REAL
/// (default) waits for real sensor data, TEST animates plausible values.
@riverpod
class TanksController extends _$TanksController {
  Timer? _driftTimer;
  final _random = Random();

  @override
  TanksState build() {
    ref.onDispose(() => _driftTimer?.cancel());
    return TanksState(tanks: _seedTanks());
  }

  List<Tank> _seedTanks() {
    return [
      for (var i = 1; i <= 3; i++)
        Tank(
          id: 'ohms0-t$i',
          name: 'T$i',
          level: 0,
          capacityLiters: 200,
          sensorType: TankSensorType.ohms0to190,
        ),
      for (var i = 1; i <= 3; i++)
        Tank(
          id: 'ohms30-t$i',
          name: 'T$i',
          level: 0,
          capacityLiters: 200,
          sensorType: TankSensorType.ohms30to240,
        ),
    ];
  }

  void setTestMode(bool enabled) {
    _driftTimer?.cancel();

    if (enabled) {
      state = state.copyWith(
        testMode: true,
        tanks: [
          for (final tank in state.tanks)
            tank.copyWith(level: 0.2 + _random.nextDouble() * 0.6),
        ],
      );
      _driftTimer = Timer.periodic(const Duration(seconds: 2), (_) => _drift());
    } else {
      state = state.copyWith(
        testMode: false,
        tanks: [for (final tank in state.tanks) tank.copyWith(level: 0)],
      );
    }
  }

  void _drift() {
    state = state.copyWith(tanks: [
      for (final tank in state.tanks)
        tank.copyWith(level: (tank.level + (_random.nextDouble() - 0.5) * 0.06).clamp(0.0, 1.0)),
    ]);
  }

  /// Updates name/capacity/sensor type — mirrors the ESP32 tank config
  /// popup (usrTankLevelPage_saveTankConfig), extended to also rename.
  void configure(
    String id, {
    required String name,
    required double capacityLiters,
    required TankSensorType sensorType,
  }) {
    state = state.copyWith(tanks: [
      for (final tank in state.tanks)
        if (tank.id == id)
          tank.copyWith(name: name, capacityLiters: capacityLiters, sensorType: sensorType)
        else
          tank,
    ]);
  }

  void addTank(TankSensorType sensorType) {
    final id = 'tank_${DateTime.now().microsecondsSinceEpoch}';
    final countInGroup = state.tanks.where((t) => t.sensorType == sensorType).length;
    final tank = Tank(
      id: id,
      name: 'T${countInGroup + 1}',
      level: state.testMode ? 0.2 + _random.nextDouble() * 0.6 : 0,
      capacityLiters: 200,
      sensorType: sensorType,
    );
    state = state.copyWith(tanks: [...state.tanks, tank]);
  }
}
