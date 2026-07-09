import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/tv_controller.dart';

/// Single press-to-toggle power control for the saloon TV.
class TvControlCard extends ConsumerWidget {
  const TvControlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watch(tvControllerProvider);
    final notifier = ref.read(tvControllerProvider.notifier);

    return LumaCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOn ? AppColors.accent.withValues(alpha: 0.16) : AppColors.gaugeTrack,
            ),
            child: Icon(
              Icons.tv_rounded,
              size: 24,
              color: isOn ? AppColors.accent : AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Saloon TV', style: AppTextStyles.bodyStrong),
                const SizedBox(height: 4),
                Text(
                  isOn ? 'ON' : 'OFF',
                  style: AppTextStyles.caption.copyWith(
                    color: isOn ? AppColors.accent : AppColors.textTertiary,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
          _PowerButton(isOn: isOn, onTap: notifier.toggle),
        ],
      ),
    );
  }
}

class _PowerButton extends StatelessWidget {
  const _PowerButton({required this.isOn, required this.onTap});

  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOn ? AppColors.accent : AppColors.gaugeTrack,
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.45),
                    blurRadius: 16,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          size: 22,
          color: isOn ? AppColors.background : AppColors.textTertiary,
        ),
      ),
    );
  }
}
