enum PressureTrend { rising, falling, steady }

class EnvironmentReading {
  const EnvironmentReading({
    required this.pressureMb,
    required this.trend,
  });

  final double pressureMb;
  final PressureTrend trend;
}
