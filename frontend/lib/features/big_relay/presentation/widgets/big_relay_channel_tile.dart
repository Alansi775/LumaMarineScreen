import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/big_relay_channel.dart';

/// Compact tile for one of 16 channels — number, output state, and a
/// small input-feedback dot in the corner.
class BigRelayChannelTile extends StatelessWidget {
  const BigRelayChannelTile({super.key, required this.channel, required this.onToggle});

  final BigRelayChannel channel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isOn = channel.outputOn;
    final color = AppColors.accent;

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          color: isOn ? color.withValues(alpha: 0.14) : AppColors.surface,
          border: Border.all(color: isOn ? color.withValues(alpha: 0.5) : AppColors.hairline),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: channel.inputOn ? AppColors.success : AppColors.textTertiary.withValues(alpha: 0.3),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${channel.index + 1}',
                    style: AppTextStyles.numeralMedium.copyWith(
                      color: isOn ? color : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: 14,
                    color: isOn ? color : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
