import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/control_panel/control_pill_button.dart';
import '../../application/shunt_relay_controller.dart';

/// The Big Shunt card's 2 relay outputs — matches
/// `relay_control_container` in usrShuntPage.c: a small rounded row
/// holding 2 pill buttons.
class ShuntRelayControls extends ConsumerWidget {
  const ShuntRelayControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relays = ref.watch(shuntRelayControllerProvider);
    final notifier = ref.read(shuntRelayControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          for (var i = 0; i < relays.length; i++) ...[
            Expanded(
              child: ControlPillButton(
                label: 'Relay ${i + 1} ${relays[i] ? 'ON' : 'OFF'}',
                active: relays[i],
                onTap: () => notifier.toggle(i),
              ),
            ),
            if (i < relays.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}
