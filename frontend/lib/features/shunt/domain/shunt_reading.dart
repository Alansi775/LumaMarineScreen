/// A single current shunt sensor reading — the main 300A shunt or one of
/// the four 30A "quadro" shunts (usrShuntPage.h `shunt_data_t`).
class ShuntReading {
  const ShuntReading({
    required this.name,
    required this.current,
    required this.voltage,
    required this.maxCurrent,
  });

  final String name;
  final double current;
  final double voltage;
  final double maxCurrent;

  double get power => current * voltage;

  ShuntReading copyWith({double? current, double? voltage}) {
    return ShuntReading(
      name: name,
      current: current ?? this.current,
      voltage: voltage ?? this.voltage,
      maxCurrent: maxCurrent,
    );
  }
}

/// A battery voltage reading, converted to percentage using the same
/// 12V lead-acid range the ESP32 project uses (10.5V empty, 14.4V full —
/// usrShuntPage_init).
class BatteryReading {
  const BatteryReading({required this.name, required this.voltage});

  final String name;
  final double voltage;

  static const _minVoltage = 10.5;
  static const _maxVoltage = 14.4;

  double get percentage =>
      ((voltage - _minVoltage) / (_maxVoltage - _minVoltage)).clamp(0.0, 1.0);

  BatteryReading copyWith({double? voltage}) {
    return BatteryReading(name: name, voltage: voltage ?? this.voltage);
  }
}
