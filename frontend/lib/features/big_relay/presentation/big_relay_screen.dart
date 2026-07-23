import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../../../core/widgets/control_panel/control_power_button.dart';
import '../../../core/widgets/control_panel/control_sidebar_button.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/big_relay_controller.dart';

/// Scrollable 16-channel sidebar (with a live input-feedback dot per row)
/// + center detail panel (power button, ACTIVE/INACTIVE, INPUT PASSIVE/
/// ACTIVE, Refresh) — matches usrBigRelayPage.c's real layout exactly.
class BigRelayScreen extends ConsumerStatefulWidget {
  const BigRelayScreen({super.key});

  @override
  ConsumerState<BigRelayScreen> createState() => _BigRelayScreenState();
}

class _BigRelayScreenState extends ConsumerState<BigRelayScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bigRelayControllerProvider);
    final notifier = ref.read(bigRelayControllerProvider.notifier);
    final selected = state.channels[_selectedIndex];

    return Column(
      children: [
        ControlPageHeader(
          icon: Icons.settings_outlined,
          title: 'BIG RELAY',
          subtitle: 'NODE NOT CONNECTED',
          trailing: const NodeStatusPill(),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 280,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(right: BorderSide(color: AppColors.hairline)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.channels.length,
                        itemBuilder: (context, i) {
                          final channel = state.channels[i];
                          return ControlSidebarButton(
                            label: 'Relay ${(i + 1).toString().padLeft(2, '0')}',
                            isSelected: i == _selectedIndex,
                            isOn: channel.outputOn,
                            onTap: () => setState(() => _selectedIndex = i),
                            trailing: channel.inputOn
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.success,
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    ControlPillButton(
                      label: 'Close All',
                      onTap: () => notifier.setAllOutputs(false),
                    ),
                    const SizedBox(height: 10),
                    ControlPillButton(
                      label: state.autoPairEnabled ? 'Auto Pair ON' : 'Auto Pair OFF',
                      active: state.autoPairEnabled,
                      onTap: () => notifier.setAutoPair(!state.autoPairEnabled),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RELAY ${(_selectedIndex + 1).toString().padLeft(2, '0')}',
                        style: AppTextStyles.title.copyWith(color: AppColors.accent, letterSpacing: 2),
                      ),
                      const SizedBox(height: 44),
                      ControlPowerButton(
                        isOn: selected.outputOn,
                        onTap: () => notifier.toggleOutput(_selectedIndex),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        selected.outputOn ? 'ACTIVE' : 'INACTIVE',
                        style: AppTextStyles.caption.copyWith(letterSpacing: 2),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        selected.inputOn ? 'INPUT ACTIVE' : 'INPUT PASSIVE',
                        style: AppTextStyles.caption.copyWith(
                          letterSpacing: 1.5,
                          color: selected.inputOn ? AppColors.success : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
