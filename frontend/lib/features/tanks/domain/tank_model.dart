/// Tank category — drives fill color and default capacity assumptions.
/// Extensible: adding `fuel` support later is just another enum case plus
/// a seed entry in [TanksController.build], no screen changes needed.
enum TankKind { freshWater, waste, fuel }

/// Resistive sender range — matches the two sensor types the ESP32
/// reference project supports (usrTankLevelPage.h `sensor_type_t`).
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
    required this.kind,
    required this.level,
    required this.capacityLiters,
    this.sensorType = TankSensorType.ohms0to190,
  });

  final String id;
  final String name;
  final TankKind kind;

  /// 0.0–1.0, sourced from a level sensor.
  final double level;
  final double capacityLiters;
  final TankSensorType sensorType;

  double get liters => level * capacityLiters;

  Tank copyWith({double? level, double? capacityLiters, TankSensorType? sensorType}) {
    return Tank(
      id: id,
      name: name,
      kind: kind,
      level: level ?? this.level,
      capacityLiters: capacityLiters ?? this.capacityLiters,
      sensorType: sensorType ?? this.sensorType,
    );
  }
}
