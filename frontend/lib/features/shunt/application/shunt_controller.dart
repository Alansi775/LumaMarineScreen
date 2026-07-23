import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/shunt_reading.dart';
import '../domain/shunt_state.dart';

part 'shunt_controller.g.dart';

/// Main shunt (300A) + 2 batteries + 4 quadro shunts (30A each) —
/// matches usrShuntPage.c's real data set exactly. TEST_MODE toggle
/// mirrors theirs: REAL (default) shows zeroed/waiting readings, TEST
/// animates plausible values (same seed numbers as their test-mode init).
@riverpod
class ShuntController extends _$ShuntController {
  Timer? _driftTimer;
  final _random = Random();

  @override
  ShuntState build() {
    ref.onDispose(() => _driftTimer?.cancel());
    return ShuntState(
      mainShunt: const ShuntReading(name: 'MAIN SHUNT', current: 0, voltage: 0, maxCurrent: 300),
      batteries: const [
        BatteryReading(name: 'MAIN BAT', voltage: 0),
        BatteryReading(name: 'BACKUP BAT', voltage: 0),
      ],
      quadroShunts: [
        for (var i = 1; i <= 4; i++)
          ShuntReading(name: 'QUADRO $i', current: 0, voltage: 0, maxCurrent: 30),
      ],
    );
  }

  void setTestMode(bool enabled) {
    _driftTimer?.cancel();

    if (enabled) {
      state = state.copyWith(
        testMode: true,
        mainShunt: state.mainShunt.copyWith(current: 45.0, voltage: 12.3),
        batteries: [
          for (var i = 0; i < state.batteries.length; i++)
            state.batteries[i].copyWith(voltage: 12.4 + i * 0.2),
        ],
        quadroShunts: [
          for (var i = 0; i < state.quadroShunts.length; i++)
            state.quadroShunts[i].copyWith(current: 15.0 + i * 3.0, voltage: 12.1 + i * 0.1),
        ],
      );
      _driftTimer = Timer.periodic(const Duration(seconds: 2), (_) => _drift());
    } else {
      state = state.copyWith(
        testMode: false,
        mainShunt: state.mainShunt.copyWith(current: 0, voltage: 0),
        batteries: [for (final b in state.batteries) b.copyWith(voltage: 0)],
        quadroShunts: [for (final q in state.quadroShunts) q.copyWith(current: 0, voltage: 0)],
      );
    }
  }

  void _drift() {
    state = state.copyWith(
      mainShunt: state.mainShunt.copyWith(
        current: (state.mainShunt.current + (_random.nextDouble() - 0.5) * 4)
            .clamp(0.0, state.mainShunt.maxCurrent),
        voltage: (state.mainShunt.voltage + (_random.nextDouble() - 0.5) * 0.05).clamp(10.5, 14.4),
      ),
      batteries: [
        for (final b in state.batteries)
          b.copyWith(voltage: (b.voltage + (_random.nextDouble() - 0.5) * 0.03).clamp(10.5, 14.4)),
      ],
      quadroShunts: [
        for (final q in state.quadroShunts)
          q.copyWith(
            current: (q.current + (_random.nextDouble() - 0.5) * 1.5).clamp(0.0, q.maxCurrent),
            voltage: (q.voltage + (_random.nextDouble() - 0.5) * 0.03).clamp(10.5, 14.4),
          ),
      ],
    );
  }
}
