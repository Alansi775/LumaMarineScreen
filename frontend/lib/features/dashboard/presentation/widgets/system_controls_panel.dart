import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../../lighting/application/lighting_controller.dart';
import '../../application/system_controls_controller.dart';
import '../../domain/system_controls_state.dart';

/// SİSTEM KONTROLLERİ — a row of icon-above-toggle controls. Lighting
/// tiles (Floor 1/2/3, Water Light) read/write the exact same
/// `lightingControllerProvider` state as the Aydınlatma Sistemi screen —
/// one light, one source of truth, toggling from either place agrees.
/// SİNTİNE POMPA is tri-state (KAPALI/AÇIK/OTOMATİK) in the reference,
/// not a plain boolean — modeled as a cycling control instead of an
/// on/off switch.
class SystemControlsPanel extends ConsumerWidget {
  const SystemControlsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lights = ref.watch(lightingControllerProvider);
    final lightingNotifier = ref.read(lightingControllerProvider.notifier);
    final state = ref.watch(systemControlsControllerProvider);
    final notifier = ref.read(systemControlsControllerProvider.notifier);

    return LumaCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.sistemKontrolleri,
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                for (final light in lights)
                  Expanded(
                    child: _ToggleTile(
                      icon: light.isOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                      label: light.name,
                      isOn: light.isOn,
                      onTap: () => lightingNotifier.toggle(light.ledNumber),
                    ),
                  ),
                Expanded(
                  child: _SintineTile(mode: state.sintinePompa, onTap: notifier.cycleSintinePompa),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.anchor_rounded,
                    label: AppStrings.irgat,
                    isOn: state.irgat,
                    onTap: notifier.toggleIrgat,
                  ),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.campaign_outlined,
                    label: AppStrings.horn,
                    isOn: state.horn,
                    onTap: notifier.toggleHorn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.icon, required this.label, required this.isOn, required this.onTap});

  final IconData icon;
  final String label;
  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isOn ? AppColors.success : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 0.2, height: 1.1),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 20,
              child: FittedBox(
                child: Switch(
                  value: isOn,
                  onChanged: (_) => onTap(),
                  activeTrackColor: AppColors.success,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SintineTile extends StatelessWidget {
  const _SintineTile({required this.mode, required this.onTap});

  final SintineMode mode;
  final VoidCallback onTap;

  Color get _color => switch (mode) {
        SintineMode.kapali => AppColors.textTertiary,
        SintineMode.acik => AppColors.success,
        SintineMode.otomatik => AppColors.accent,
      };

  String get _label => switch (mode) {
        SintineMode.kapali => AppStrings.kapali,
        SintineMode.acik => AppStrings.acik,
        SintineMode.otomatik => AppStrings.otomatik,
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reuses what used to be Pompa 1's icon — Pompa 1/2 and Klima
            // were removed from this panel per client direction.
            Icon(Icons.water_rounded, size: 20, color: _color),
            const SizedBox(height: 4),
            const Text(
              AppStrings.sintinePompa,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 0.2, height: 1.1),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _color.withValues(alpha: 0.5)),
              ),
              child: Text(_label, style: TextStyle(color: _color, fontSize: 8.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
