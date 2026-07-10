import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/tank_model.dart';

part 'tanks_controller.g.dart';

/// Live tank telemetry + the one write action a captain actually needs:
/// pumping the waste tank out. Fresh water drips down and waste creeps up
/// on a timer to simulate a real level sensor feed — Phase 1 has no
/// hardware yet, but the UI should already feel like it's watching one.
@riverpod
class TanksController extends _$TanksController {
  Timer? _driftTimer;
  final _random = Random();

  @override
  List<Tank> build() {
    _driftTimer = Timer.periodic(const Duration(seconds: 2), (_) => _drift());
    ref.onDispose(() => _driftTimer?.cancel());

    return const [
      Tank(
        id: 'fresh',
        name: 'Fresh Water',
        kind: TankKind.freshWater,
        level: 0.82,
        capacityLiters: 400,
      ),
      Tank(
        id: 'waste',
        name: 'Waste Water',
        kind: TankKind.waste,
        level: 0.18,
        capacityLiters: 150,
      ),
    ];
  }

  void _drift() {
    state = [
      for (final tank in state)
        switch (tank.kind) {
          TankKind.freshWater => tank.copyWith(
              level: (tank.level - 0.004 - _random.nextDouble() * 0.004)
                  .clamp(0.0, 1.0),
            ),
          TankKind.waste => tank.copyWith(
              level: (tank.level + 0.004 + _random.nextDouble() * 0.004)
                  .clamp(0.0, 1.0),
            ),
          TankKind.fuel => tank,
        },
    ];
  }

  /// Pumps a tank empty immediately — the physical action a "PRESS TO
  /// EMPTY" waste tank maps to.
  void empty(String id) {
    state = [
      for (final tank in state)
        if (tank.id == id) tank.copyWith(level: 0) else tank,
    ];
  }

  /// Updates capacity + sensor type — mirrors the ESP32 tank config popup
  /// (usrTankLevelPage_saveTankConfig).
  void configure(String id, {required double capacityLiters, required TankSensorType sensorType}) {
    state = [
      for (final tank in state)
        if (tank.id == id)
          tank.copyWith(capacityLiters: capacityLiters, sensorType: sensorType)
        else
          tank,
    ];
  }
}
