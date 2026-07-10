import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/luma_card.dart';
import '../../../core/widgets/section_label.dart';
import '../application/toilet_controller.dart';
import 'widgets/toilet_channel_row.dart';

class ToiletScreen extends ConsumerWidget {
  const ToiletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(toiletControllerProvider);
    final notifier = ref.read(toiletControllerProvider.notifier);

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
            const SectionLabel('TOILET / PUMPS'),
            const SizedBox(height: 20),
            Expanded(
              child: LumaCard(
                child: ListView.separated(
                  itemCount: channels.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => ToiletChannelRow(
                    channel: channels[i],
                    onToggle: () => notifier.toggle(channels[i].id),
                    onPwmChanged: (v) => notifier.setPwm(channels[i].id, v),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
