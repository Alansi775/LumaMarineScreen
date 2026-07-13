import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../../../core/widgets/section_label.dart';
import '../../batteries/presentation/widgets/shunt_relay_row.dart';
import '../application/big_relay_controller.dart';
import 'widgets/big_relay_channel_tile.dart';

class BigRelayScreen extends ConsumerWidget {
  const BigRelayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bigRelayControllerProvider);
    final notifier = ref.read(bigRelayControllerProvider.notifier);
    final onCount = state.channels.where((c) => c.outputOn).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding,
          AppDimensions.pagePadding + 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(
              'BIG RELAY',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NodeStatusPill(),
                  const SizedBox(width: 16),
                  Text('$onCount / 16 ON', style: AppTextStyles.sectionLabel),
                  const SizedBox(width: 20),
                  _AutoPairSwitch(
                    enabled: state.autoPairEnabled,
                    onChanged: notifier.setAutoPair,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => notifier.setAllOutputs(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Text('ALL OFF', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  for (final channel in state.channels)
                    BigRelayChannelTile(
                      channel: channel,
                      onToggle: () => notifier.toggleOutput(channel.index),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionLabel('SHUNT RELAYS'),
            const SizedBox(height: 12),
            const ShuntRelayRow(),
          ],
        ),
      ),
    );
  }
}

class _AutoPairSwitch extends StatelessWidget {
  const _AutoPairSwitch({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!enabled),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('AUTO PAIR', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 20,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: enabled ? AppColors.accent : AppColors.gaugeTrack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
