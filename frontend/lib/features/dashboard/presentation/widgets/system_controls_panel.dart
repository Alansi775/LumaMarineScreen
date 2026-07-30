import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/luma_card.dart';
import '../../application/system_controls_controller.dart';
import '../../domain/system_controls_state.dart';

/// SİSTEM KONTROLLERİ — a row of icon-above-toggle controls. Every
/// control here is confirmed "fully real": each already has its own CAN
/// id and sends a real packet once hardware is connected. SİNTİNE POMPA
/// is tri-state (KAPALI/AÇIK/OTOMATİK) in the reference, not a plain
/// boolean — modeled as a cycling control instead of an on/off switch.
class SystemControlsPanel extends ConsumerWidget {
  const SystemControlsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.lightbulb_outline_rounded,
                    label: AppStrings.icAydinlatma,
                    isOn: state.icAydinlatma,
                    onTap: notifier.toggleIcAydinlatma,
                  ),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.wb_incandescent_outlined,
                    label: AppStrings.disAydinlatma,
                    isOn: state.disAydinlatma,
                    onTap: notifier.toggleDisAydinlatma,
                  ),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.water_rounded,
                    label: AppStrings.pompa1,
                    isOn: state.pompa1,
                    onTap: notifier.togglePompa1,
                  ),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.water_rounded,
                    label: AppStrings.pompa2,
                    isOn: state.pompa2,
                    onTap: notifier.togglePompa2,
                  ),
                ),
                Expanded(
                  child: _SintineTile(mode: state.sintinePompa, onTap: notifier.cycleSintinePompa),
                ),
                Expanded(
                  child: _ToggleTile(
                    icon: Icons.ac_unit_rounded,
                    label: AppStrings.klima,
                    isOn: state.klima,
                    onTap: notifier.toggleKlima,
                  ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: isOn ? AppColors.success : AppColors.textSecondary),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 8, letterSpacing: 0.2),
            ),
            const SizedBox(height: 6),
            Text(
              isOn ? AppStrings.acik : AppStrings.kapali,
              style: TextStyle(
                color: isOn ? AppColors.success : AppColors.textTertiary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Switch(
              value: isOn,
              onChanged: (_) => onTap(),
              activeTrackColor: AppColors.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_damage_outlined, size: 22, color: _color),
            const SizedBox(height: 6),
            const Text(
              AppStrings.sintinePompa,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 8, letterSpacing: 0.2),
            ),
            const SizedBox(height: 6),
            Text(_label, style: TextStyle(color: _color, fontSize: 9, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _color.withValues(alpha: 0.5)),
              ),
              child: Icon(Icons.sync_alt_rounded, size: 14, color: _color),
            ),
          ],
        ),
      ),
    );
  }
}
