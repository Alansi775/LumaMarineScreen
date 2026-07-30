class EngineReading {
  const EngineReading({
    required this.rpm,
    required this.tempC,
    required this.oilBar,
    required this.loadPercent,
  });

  final int rpm;
  final double tempC;
  final double oilBar;
  final double loadPercent;

  bool get isHot => tempC >= 95;
}
