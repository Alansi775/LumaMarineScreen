import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/dashboard_bus_service.dart';
import '../../../core/telemetry/dashboard_can_ids.dart';
import '../domain/tank_reading.dart';

part 'tank_levels_controller.g.dart';

const _tankCapacities = {
  DashboardTankType.yakit: 1200.0,
  DashboardTankType.tatliSu: 800.0,
  DashboardTankType.pisSu: 400.0,
  DashboardTankType.sintine: 150.0,
};

const _tankCanIds = {
  DashboardTankType.yakit: DashboardCanIds.tankYakit,
  DashboardTankType.tatliSu: DashboardCanIds.tankTatliSu,
  DashboardTankType.pisSu: DashboardCanIds.tankPisSu,
  DashboardTankType.sintine: DashboardCanIds.tankSintine,
};

TankReading _mockTank(Random random, DashboardTankType type, double basePercent) {
  final percent = (basePercent + random.nextDouble() * 4 - 2).clamp(0.0, 100.0);
  final capacity = _tankCapacities[type]!;
  return TankReading(type: type, percent: percent, liters: capacity * percent / 100);
}

/// TANK SEVİYELERİ — sensors already installed per the client (this is
/// "fully real" once hardware is connected, no placeholder caveat),
/// backed by the mock bus the same way real telemetry will be later.
@riverpod
class TankLevelsController extends _$TankLevelsController {
  final _random = Random();

  static const _baseline = {
    DashboardTankType.yakit: 72.0,
    DashboardTankType.tatliSu: 58.0,
    DashboardTankType.pisSu: 34.0,
    DashboardTankType.sintine: 8.0,
  };

  @override
  List<TankReading> build() {
    final bus = ref.watch(dashboardBusServiceProvider);
    final subs = <StreamSubscription<DashboardFrame>>[];

    for (final type in DashboardTankType.values) {
      final canId = _tankCanIds[type]!;
      bus.ensureMockChannel(canId, () => _mockTank(_random, type, _baseline[type]!));
      subs.add(bus.frames(canId).listen((f) {
        final reading = f.payload as TankReading;
        state = [for (final t in state) if (t.type == type) reading else t];
      }));
    }

    ref.onDispose(() {
      for (final s in subs) {
        s.cancel();
      }
    });

    return [for (final type in DashboardTankType.values) _mockTank(_random, type, _baseline[type]!)];
  }
}
