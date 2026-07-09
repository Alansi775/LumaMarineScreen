/// Snapshot reading for the main house battery bank.
class BatteryModel {
  const BatteryModel({
    required this.percentage,
    required this.voltage,
    required this.amps,
    required this.timeRemaining,
    required this.isCharging,
  });

  /// 0.0–1.0
  final double percentage;
  final double voltage;

  /// Positive while charging, negative while discharging.
  final double amps;
  final Duration timeRemaining;
  final bool isCharging;
}
