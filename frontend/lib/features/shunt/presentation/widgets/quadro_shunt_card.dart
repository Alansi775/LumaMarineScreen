import 'package:flutter/material.dart';

import '../../../../core/widgets/vertical_bar_gauge.dart';
import '../../domain/shunt_reading.dart';

/// One of the 4 "quadro" 30A shunts — matches `quadro_containers[i]` in
/// usrShuntPage.c: name/max label, vertical bar, "A / V / W" value block.
/// Borderless glass panel, matches the premium look on Lighting/Tanks.
class QuadroShuntCard extends StatelessWidget {
  const QuadroShuntCard({super.key, required this.reading, required this.color});

  final ShuntReading reading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        children: [
          Text(
            '${reading.name}\n${reading.maxCurrent.round()}A MAX',
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.5),
          ),
          const SizedBox(height: 14),
          VerticalBarGauge(
            value: reading.current / reading.maxCurrent,
            color: color,
            width: 34,
            height: 130,
          ),
          const SizedBox(height: 14),
          Text(
            '${reading.current.toStringAsFixed(1)}A\n${reading.voltage.toStringAsFixed(1)}V\n${reading.power.toStringAsFixed(1)}W',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 0.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
