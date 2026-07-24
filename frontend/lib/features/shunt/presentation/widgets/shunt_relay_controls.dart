import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/control_panel/control_pill_button.dart';
import '../../application/shunt_relay_controller.dart';

/// The Big Shunt card's 2 relay outputs — matches
/// `relay_control_container` in usrShuntPage.c: a small row holding 2
/// pill buttons. Borderless, matches the premium look on Lighting/Tanks.
class ShuntRelayControls extends ConsumerWidget {
  const ShuntRelayControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relays = ref.watch(shuntRelayControllerProvider);
    final notifier = ref.read(shuntRelayControllerProvider.notifier);

    return Row(
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
    );
  }
}
