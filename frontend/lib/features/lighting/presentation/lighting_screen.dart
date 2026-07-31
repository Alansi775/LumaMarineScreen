import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/luma_card.dart';
import '../application/lighting_controller.dart';
import '../domain/light_channel.dart';
import '../domain/yacht_light_image.dart';
import 'widgets/rename_light_sheet.dart';

/// AYDINLATMA SİSTEMİ — same sidebar-select + center-detail structure as
/// the old ESP32-parity Lighting page (6 PWM channels + dimmer), just 4
/// channels this time and the new flat panel design. The yacht photo
/// sits center-stage and swaps live as lights toggle, so the operator
/// sees the effect of every press immediately.
class LightingScreen extends ConsumerStatefulWidget {
  const LightingScreen({super.key});

  @override
  ConsumerState<LightingScreen> createState() => _LightingScreenState();
}

class _LightingScreenState extends ConsumerState<LightingScreen> {
  int _selectedLed = 1;

  @override
  Widget build(BuildContext context) {
    final channels = ref.watch(lightingControllerProvider);
    final notifier = ref.read(lightingControllerProvider.notifier);
    final assignment = ref.watch(ledNodeAssignmentProvider).valueOrNull;

    final selected = channels.firstWhere(
      (c) => c.ledNumber == _selectedLed,
      orElse: () => channels.first,
    );

    bool isOn(int ledNumber) => channels.firstWhere((c) => c.ledNumber == ledNumber, orElse: () => channels.first).isOn;

    final imageAsset = yachtImageAssetFor(
      floor1: isOn(1),
      floor2: isOn(2),
      floor3: isOn(3),
      water: isOn(4),
    );

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'AYDINLATMA SİSTEMİ',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
                const Spacer(),
                _LedNodeStatusPill(assignedId: assignment?.assignedId, active: assignment?.active ?? false),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 260,
                    child: LumaCard(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          for (final channel in channels)
                            _ChannelListTile(
                              channel: channel,
                              isSelected: channel.ledNumber == _selectedLed,
                              onSelect: () => setState(() => _selectedLed = channel.ledNumber),
                              onToggle: () => notifier.toggle(channel.ledNumber),
                              onRename: () => showRenameLightSheet(context, channel.ledNumber, channel.name),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 3,
                    child: LumaCard(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium - 4),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: Image.asset(
                            imageAsset,
                            key: ValueKey(imageAsset),
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 260,
                    child: LumaCard(
                      padding: const EdgeInsets.all(18),
                      child: _ChannelDetail(
                        channel: selected,
                        onToggle: () => notifier.toggle(selected.ledNumber),
                        onBrightness: (v) => notifier.setBrightness(selected.ledNumber, v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedNodeStatusPill extends StatelessWidget {
  const _LedNodeStatusPill({required this.assignedId, required this.active});

  final int? assignedId;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.success : AppColors.warning;
    final label = active
        ? 'BOARD BAĞLI · 0x${assignedId!.toRadixString(16).toUpperCase()}'
        : 'BOARD BAĞLI DEĞİL';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _ChannelListTile extends StatelessWidget {
  const _ChannelListTile({
    required this.channel,
    required this.isSelected,
    required this.onSelect,
    required this.onToggle,
    required this.onRename,
  });

  final LightChannel channel;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onToggle;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? AppColors.accent.withValues(alpha: 0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  channel.isOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: channel.isOn ? AppColors.success : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    channel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onRename,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.edit_outlined, size: 15, color: AppColors.textTertiary),
                  ),
                ),
                Switch(
                  value: channel.isOn,
                  onChanged: (_) => onToggle(),
                  activeTrackColor: AppColors.success,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelDetail extends StatelessWidget {
  const _ChannelDetail({required this.channel, required this.onToggle, required this.onBrightness});

  final LightChannel channel;
  final VoidCallback onToggle;
  final ValueChanged<int> onBrightness;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          channel.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHighlight,
              border: Border.all(
                color: channel.isOn ? AppColors.success.withValues(alpha: 0.6) : AppColors.hairline,
                width: 1.5,
              ),
              boxShadow: channel.isOn
                  ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.25), blurRadius: 26, spreadRadius: 4)]
                  : null,
            ),
            child: Icon(
              Icons.power_settings_new_rounded,
              size: 40,
              color: channel.isOn ? AppColors.success : AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          channel.isOn ? 'AÇIK' : 'KAPALI',
          style: TextStyle(
            color: channel.isOn ? AppColors.success : AppColors.textTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 28),
        Text('PARLAKLIK', style: TextStyle(color: AppColors.textTertiary, fontSize: 10, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(
          '%${(channel.brightness / 10).round()}',
          style: TextStyle(
            color: channel.isOn ? Colors.white : AppColors.textTertiary,
            fontSize: 30,
            fontWeight: FontWeight.w200,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.hairline,
                thumbColor: Colors.white,
                overlayColor: AppColors.accent.withValues(alpha: 0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: channel.brightness.toDouble().clamp(0, 1000),
                min: 0,
                max: 1000,
                onChanged: channel.isOn ? (v) => onBrightness(v.round()) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
