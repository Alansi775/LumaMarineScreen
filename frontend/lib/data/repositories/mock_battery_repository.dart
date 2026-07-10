import 'dart:math';

import 'package:flutter/material.dart';

import '../../features/batteries/domain/battery_model.dart';
import '../../features/batteries/domain/circuit_model.dart';
import 'battery_repository.dart';

/// Fake data source for Phase 1 UI work. Emits gently fluctuating readings
/// on a timer so the dashboard reads as "live" without any real hardware.
class MockBatteryRepository implements BatteryRepository {
  final _random = Random();

  @override
  Stream<BatteryModel> watchMainBattery() async* {
    var percentage = 0.78;
    var amps = 12.4;
    while (true) {
      percentage = (percentage + (_random.nextDouble() - 0.5) * 0.01)
          .clamp(0.15, 0.98);
      amps = (amps + (_random.nextDouble() - 0.5) * 0.6).clamp(-4, 22);
      yield BatteryModel(
        percentage: percentage,
        voltage: 12.6 + percentage * 1.1,
        amps: amps,
        timeRemaining: Duration(hours: 14, minutes: 20 + _random.nextInt(10)),
        isCharging: amps >= 0,
      );
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Stream<BatteryModel> watchBackupBattery() async* {
    var percentage = 0.96;
    while (true) {
      percentage = (percentage + (_random.nextDouble() - 0.5) * 0.004).clamp(0.85, 1.0);
      yield BatteryModel(
        percentage: percentage,
        voltage: 12.6 + percentage * 1.1,
        amps: 0.1,
        timeRemaining: const Duration(hours: 48),
        isCharging: true,
      );
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Stream<List<CircuitModel>> watchCircuits() async* {
    while (true) {
      yield [
        CircuitModel(
          id: 'lights',
          name: 'Lights',
          icon: Icons.lightbulb_outline,
          amps: 3.2 + _random.nextDouble() * 0.4,
          maxAmps: 10,
        ),
        CircuitModel(
          id: 'fridge',
          name: 'Refrigerator',
          icon: Icons.kitchen_outlined,
          amps: 5.8 + _random.nextDouble() * 0.5,
          maxAmps: 10,
        ),
        CircuitModel(
          id: 'instruments',
          name: 'Instruments',
          icon: Icons.speed_outlined,
          amps: 1.4 + _random.nextDouble() * 0.2,
          maxAmps: 10,
        ),
        CircuitModel(
          id: 'solar',
          name: 'Solar Panel',
          icon: Icons.solar_power_outlined,
          amps: 9.1 + _random.nextDouble() * 0.8,
          maxAmps: 15,
          isSource: true,
        ),
      ];
      await Future.delayed(const Duration(seconds: 4));
    }
  }
}
