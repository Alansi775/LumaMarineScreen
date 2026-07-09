import 'dart:math';

import '../../features/overview/domain/environment_reading.dart';
import 'environment_repository.dart';

class MockEnvironmentRepository implements EnvironmentRepository {
  final _random = Random();

  @override
  Stream<EnvironmentReading> watchEnvironment() async* {
    var pressure = 1013.0;
    while (true) {
      final delta = (_random.nextDouble() - 0.5) * 0.6;
      pressure = (pressure + delta).clamp(985.0, 1040.0);
      yield EnvironmentReading(
        pressureMb: pressure,
        trend: delta > 0.08
            ? PressureTrend.rising
            : delta < -0.08
                ? PressureTrend.falling
                : PressureTrend.steady,
      );
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
