/// Tank category — drives fill color and default capacity assumptions.
/// Extensible: adding `fuel` support later is just another enum case plus
/// a seed entry in [TanksController.build], no screen changes needed.
enum TankKind { freshWater, waste, fuel }

class Tank {
  const Tank({
    required this.id,
    required this.name,
    required this.kind,
    required this.level,
    required this.capacityLiters,
  });

  final String id;
  final String name;
  final TankKind kind;

  /// 0.0–1.0, sourced from a level sensor.
  final double level;
  final double capacityLiters;

  double get liters => level * capacityLiters;

  Tank copyWith({double? level}) {
    return Tank(
      id: id,
      name: name,
      kind: kind,
      level: level ?? this.level,
      capacityLiters: capacityLiters,
    );
  }
}
