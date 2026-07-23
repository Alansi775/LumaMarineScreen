import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/vertical_bar_gauge.dart';
import '../../domain/shunt_reading.dart';

/// One of the 4 "quadro" 30A shunts — matches `quadro_containers[i]` in
/// usrShuntPage.c: name/max label, vertical bar, "A / V / W" value block.
class QuadroShuntCard extends StatelessWidget {
  const QuadroShuntCard({super.key, required this.reading, required this.color});

  final ShuntReading reading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            '${reading.name}\n(${reading.maxCurrent.round()}A MAX)',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: color, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          VerticalBarGauge(
            value: reading.current / reading.maxCurrent,
            color: color,
            width: 34,
            height: 130,
          ),
          const SizedBox(height: 12),
          Text(
            '${reading.current.toStringAsFixed(1)}A\n${reading.voltage.toStringAsFixed(1)}V\n${reading.power.toStringAsFixed(1)}W',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
