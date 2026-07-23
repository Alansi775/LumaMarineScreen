import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/shunt_reading.dart';

/// The horizontal 300A main shunt bar — matches `main_shunt_container`
/// in usrShuntPage.c: name label, horizontal fill bar, "A | V | W" value
/// line below.
class MainShuntCard extends StatelessWidget {
  const MainShuntCard({super.key, required this.reading});

  final ShuntReading reading;

  @override
  Widget build(BuildContext context) {
    final fraction = (reading.current / reading.maxCurrent).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'MAIN SHUNT (${reading.maxCurrent.round()}A MAX)',
            style: AppTextStyles.bodyStrong.copyWith(color: AppColors.accent, letterSpacing: 1.2),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: fraction, end: fraction),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 14,
                backgroundColor: AppColors.gaugeTrack,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${reading.current.toStringAsFixed(1)}A | ${reading.voltage.toStringAsFixed(1)}V | ${reading.power.toStringAsFixed(1)}W',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
