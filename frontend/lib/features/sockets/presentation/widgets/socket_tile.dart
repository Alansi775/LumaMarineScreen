import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/socket_model.dart';

/// Relay-controlled outlet tile — same satisfying on-glow language as
/// [LightTile], power-plug iconography instead of a bulb.
class SocketTile extends StatelessWidget {
  const SocketTile({super.key, required this.socket, required this.onToggle});

  final SocketModel socket;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isOn = socket.isOn;
    final color = AppColors.solar;

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isOn ? color.withValues(alpha: 0.55) : AppColors.hairline,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isOn
                ? [color.withValues(alpha: 0.2), AppColors.surface]
                : [AppColors.surfaceRaised.withValues(alpha: 0.5), AppColors.surface],
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.26),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? color.withValues(alpha: 0.16) : AppColors.gaugeTrack,
              ),
              child: Icon(
                Icons.power_outlined,
                size: 24,
                color: isOn ? color : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              socket.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyStrong.copyWith(
                color: isOn ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isOn ? 'ON' : 'OFF',
              style: AppTextStyles.caption.copyWith(
                color: isOn ? color : AppColors.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
