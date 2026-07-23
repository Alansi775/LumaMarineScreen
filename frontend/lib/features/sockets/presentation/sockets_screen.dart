import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../../../core/widgets/control_panel/control_power_button.dart';
import '../../../core/widgets/control_panel/control_sidebar_button.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/sockets_controller.dart';

/// Sidebar (6 channels) + center detail (power button) — no right panel,
/// relays are on/off only. Matches usrSocketsPage.c's real layout.
class SocketsScreen extends ConsumerStatefulWidget {
  const SocketsScreen({super.key});

  @override
  ConsumerState<SocketsScreen> createState() => _SocketsScreenState();
}

class _SocketsScreenState extends ConsumerState<SocketsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sockets = ref.watch(socketsControllerProvider);
    final notifier = ref.read(socketsControllerProvider.notifier);

    final index = _selectedIndex.clamp(0, sockets.length - 1);
    final selected = sockets[index];

    return Column(
      children: [
        ControlPageHeader(
          icon: Icons.power_outlined,
          title: 'SOCKETS',
          subtitle: 'RELAY CONTROL',
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
                        itemCount: sockets.length,
                        itemBuilder: (context, i) => ControlSidebarButton(
                          label: sockets[i].name,
                          isSelected: i == index,
                          isOn: sockets[i].isOn,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      ),
                    ),
                    ControlPillButton(label: 'Close All', onTap: notifier.allOff),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selected.name.toUpperCase(),
                        style: AppTextStyles.title.copyWith(color: AppColors.accent, letterSpacing: 2),
                      ),
                      const SizedBox(height: 44),
                      ControlPowerButton(
                        isOn: selected.isOn,
                        onTap: () => notifier.toggle(selected.id),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        selected.isOn ? 'ACTIVE' : 'INACTIVE',
                        style: AppTextStyles.caption.copyWith(letterSpacing: 2),
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
