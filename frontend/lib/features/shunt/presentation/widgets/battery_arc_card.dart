import 'package:flutter/material.dart';

import '../../../../core/widgets/circular_gauge.dart';
import '../../domain/shunt_reading.dart';

/// A 270° battery arc — matches `battery_arcs[i]` in usrShuntPage.c
/// exactly (135°-45° background angle = 270° sweep), name on top,
/// voltage centered, percentage at bottom.
class BatteryArcCard extends StatelessWidget {
  const BatteryArcCard({super.key, required this.reading, required this.color});

  final BatteryReading reading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading.name,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 2),
        ),
        const SizedBox(height: 12),
        CircularGauge(
          value: reading.percentage,
          size: 150,
          color: color,
          strokeWidth: 10,
          startAngleDeg: 135,
          sweepAngleDeg: 270,
          centerLabel: Text(
            '${reading.voltage.toStringAsFixed(1)}V',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(reading.percentage * 100).round()}%',
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1),
        ),
      ],
    );
  }
}
