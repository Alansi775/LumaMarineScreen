/// Resistive sender range — matches the two sensor types the ESP32
/// reference project supports (usrTankLevelPage.h `sensor_type_t`), and
/// the two rows its real Tank Level grid organizes tanks into.
enum TankSensorType { ohms0to190, ohms30to240 }

extension TankSensorTypeLabel on TankSensorType {
  String get label => switch (this) {
        TankSensorType.ohms0to190 => '0–190Ω',
        TankSensorType.ohms30to240 => '30–240Ω',
      };
}

class Tank {
  const Tank({
    required this.id,
    required this.name,
    required this.level,
    required this.capacityLiters,
    required this.sensorType,
  });

  final String id;
  final String name;

  /// 0.0–1.0, sourced from a level sensor.
  final double level;
  final double capacityLiters;
  final TankSensorType sensorType;

  double get liters => level * capacityLiters;

  Tank copyWith({
    String? name,
    double? level,
    double? capacityLiters,
    TankSensorType? sensorType,
  }) {
    return Tank(
      id: id,
      name: name ?? this.name,
      level: level ?? this.level,
      capacityLiters: capacityLiters ?? this.capacityLiters,
      sensorType: sensorType ?? this.sensorType,
    );
  }
}
