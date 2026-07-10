import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/shunt_relay_controller.dart';

/// The Big Shunt card's 2 relay outputs, exposed as simple toggle chips.
class ShuntRelayRow extends ConsumerWidget {
  const ShuntRelayRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relays = ref.watch(shuntRelayControllerProvider);
    final notifier = ref.read(shuntRelayControllerProvider.notifier);

    return LumaCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          for (var i = 0; i < relays.length; i++) ...[
            Expanded(child: _RelayChip(index: i, isOn: relays[i], onTap: () => notifier.toggle(i))),
            if (i < relays.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _RelayChip extends StatelessWidget {
  const _RelayChip({required this.index, required this.isOn, required this.onTap});

  final int index;
  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.accent;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isOn ? color.withValues(alpha: 0.16) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: Border.all(color: isOn ? color : AppColors.hairline),
        ),
        child: Text(
          'RELAY ${index + 1}',
          style: AppTextStyles.caption.copyWith(
            letterSpacing: 1.2,
            color: isOn ? color : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
