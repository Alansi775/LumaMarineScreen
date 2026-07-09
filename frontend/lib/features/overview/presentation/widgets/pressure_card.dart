import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/overview_providers.dart';
import '../../domain/environment_reading.dart';

class PressureCard extends ConsumerWidget {
  const PressureCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reading = ref.watch(environmentProvider).valueOrNull;

    final (icon, color) = switch (reading?.trend) {
      PressureTrend.rising => (Icons.trending_up_rounded, AppColors.success),
      PressureTrend.falling => (Icons.trending_down_rounded, AppColors.warning),
      _ => (Icons.trending_flat_rounded, AppColors.textSecondary),
    };

    return LumaCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SectionLabel('BAROMETRIC PRESSURE'),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    reading?.pressureMb.toStringAsFixed(0) ?? '—',
                    style: AppTextStyles.cardNumeral,
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('mb', style: AppTextStyles.unit),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 18),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }
}
