import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/shunt_reading.dart';

/// The horizontal 300A main shunt bar — matches `main_shunt_container`
/// in usrShuntPage.c: name label, horizontal fill bar, "A | V | W" value
/// line below. Borderless glass panel, matches the premium look on
/// Lighting/Tanks.
class MainShuntCard extends StatelessWidget {
  const MainShuntCard({super.key, required this.reading});

  final ShuntReading reading;

  @override
  Widget build(BuildContext context) {
    final fraction = (reading.current / reading.maxCurrent).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Text(
            'MAIN SHUNT · ${reading.maxCurrent.round()}A MAX',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: fraction, end: fraction),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
              builder: (context, value, _) => Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.35), blurRadius: 12)],
                ),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation(AppColors.accent),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${reading.current.toStringAsFixed(1)}A  ·  ${reading.voltage.toStringAsFixed(1)}V  ·  ${reading.power.toStringAsFixed(1)}W',
            style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
