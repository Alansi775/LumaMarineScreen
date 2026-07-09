import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/circuit_model.dart';

/// One circuit: icon, name, a horizontal fill bar sized by current draw,
/// and the amp readout.
class CircuitRow extends StatelessWidget {
  const CircuitRow({super.key, required this.circuit});

  final CircuitModel circuit;

  @override
  Widget build(BuildContext context) {
    final color = circuit.isSource ? AppColors.solar : AppColors.accent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(circuit.icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 3,
            child: Text(circuit.name, style: AppTextStyles.bodyStrong),
          ),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: circuit.fraction,
                minHeight: 8,
                backgroundColor: AppColors.gaugeTrack,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 64,
            child: Text(
              '${circuit.isSource ? '+' : ''}${circuit.amps.toStringAsFixed(1)}A',
              textAlign: TextAlign.right,
              style: AppTextStyles.numeralMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
