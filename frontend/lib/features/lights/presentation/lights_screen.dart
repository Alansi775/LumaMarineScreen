import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/control_panel/control_page_header.dart';
import '../../../core/widgets/control_panel/control_pill_button.dart';
import '../../../core/widgets/control_panel/control_power_button.dart';
import '../../../core/widgets/control_panel/control_sidebar_button.dart';
import '../../../core/widgets/control_panel/segmented_intensity_bar.dart';
import '../../../core/widgets/node_status_pill.dart';
import '../application/lights_controller.dart';
import 'widgets/add_light_sheet.dart';

/// Sidebar (channel list) + center detail (power button) + right panel
/// (brightness) — matches usrLightingPage.c's real layout exactly, our
/// own visual polish only ("light touches", not a new design).
class LightsScreen extends ConsumerStatefulWidget {
  const LightsScreen({super.key});

  @override
  ConsumerState<LightsScreen> createState() => _LightsScreenState();
}

class _LightsScreenState extends ConsumerState<LightsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lights = ref.watch(lightsControllerProvider);
    final notifier = ref.read(lightsControllerProvider.notifier);

    final index = _selectedIndex.clamp(0, lights.length - 1);
    final selected = lights[index];
    final hasSlider = index < 6;

    return Column(
      children: [
        ControlPageHeader(
          icon: Icons.lightbulb_outline,
          title: 'LIGHTING',
          subtitle: 'CONTROL PANEL',
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
                        itemCount: lights.length,
                        itemBuilder: (context, i) => ControlSidebarButton(
                          label: lights[i].name,
                          isSelected: i == index,
                          isOn: lights[i].isOn,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      ),
                    ),
                    ControlPillButton(
                      label: '+ ADD LIGHT',
                      onTap: () => showAddLightSheet(context),
                    ),
                    const SizedBox(height: 10),
                    ControlPillButton(label: 'Close All', onTap: notifier.closeAll),
                  ],
                ),
              ),
              Expanded(
                flex: hasSlider ? 3 : 4,
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
              if (hasSlider)
                Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(left: BorderSide(color: AppColors.hairline)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${(selected.brightness / 10).round()}%',
                        style: AppTextStyles.cardNumeral,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SegmentedIntensityBar(
                          value: selected.brightness,
                          enabled: selected.isOn,
                          onChanged: (v) => notifier.setBrightness(selected.id, v),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('INTENSITY', style: AppTextStyles.caption.copyWith(letterSpacing: 2)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
