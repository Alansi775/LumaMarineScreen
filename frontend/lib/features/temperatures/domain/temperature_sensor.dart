/// A single temperature probe. Each sensor carries its own scale (a
/// freezer and an engine room don't share a useful min/max) so the bar
/// gauge fill is always meaningful regardless of what's being measured.
class TemperatureSensor {
  const TemperatureSensor({
    required this.id,
    required this.name,
    required this.celsius,
    required this.minScale,
    required this.maxScale,
  });

  final String id;
  final String name;
  final double celsius;
  final double minScale;
  final double maxScale;

  double get fraction =>
      ((celsius - minScale) / (maxScale - minScale)).clamp(0.0, 1.0);

  TemperatureSensor copyWith({double? celsius}) {
    return TemperatureSensor(
      id: id,
      name: name,
      celsius: celsius ?? this.celsius,
      minScale: minScale,
      maxScale: maxScale,
    );
  }
}
