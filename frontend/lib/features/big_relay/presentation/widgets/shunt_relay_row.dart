import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/shunt_relay_controller.dart';

/// The Big Shunt card's 2 relay outputs (usrShuntPage.h) — not part of
/// the real Big Relay page, but the closest home for "extra relay
/// controls" in our nav model. Same glowing tile treatment as
/// Lights/Sockets.
class ShuntRelayRow extends ConsumerWidget {
  const ShuntRelayRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relays = ref.watch(shuntRelayControllerProvider);
    final notifier = ref.read(shuntRelayControllerProvider.notifier);

    return Row(
      children: [
        for (var i = 0; i < relays.length; i++) ...[
          Expanded(
            child: _ShuntRelayTile(
              index: i,
              isOn: relays[i],
              onToggle: () => notifier.toggle(i),
            ),
          ),
          if (i < relays.length - 1) const SizedBox(width: AppDimensions.gutter),
        ],
      ],
    );
  }
}

class _ShuntRelayTile extends StatelessWidget {
  const _ShuntRelayTile({required this.index, required this.isOn, required this.onToggle});

  final int index;
  final bool isOn;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.accent;

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                    blurRadius: 22,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? color.withValues(alpha: 0.16) : AppColors.gaugeTrack,
              ),
              child: Icon(
                Icons.electrical_services_rounded,
                size: 20,
                color: isOn ? color : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RELAY ${index + 1}',
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: isOn ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOn ? 'ON' : 'OFF',
                  style: AppTextStyles.caption.copyWith(
                    color: isOn ? color : AppColors.textTertiary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
