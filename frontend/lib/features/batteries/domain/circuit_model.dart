import 'package:flutter/widgets.dart';

/// A single monitored DC circuit (a load drawing current, or a source
/// feeding it, e.g. solar input).
class CircuitModel {
  const CircuitModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.amps,
    required this.maxAmps,
    this.isSource = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final double amps;

  /// Used to normalize [amps] into a 0.0–1.0 fill fraction for the bar.
  final double maxAmps;

  /// True for inputs like solar (drawn as a positive/incoming bar).
  final bool isSource;

  double get fraction => (amps / maxAmps).clamp(0.0, 1.0);
}
