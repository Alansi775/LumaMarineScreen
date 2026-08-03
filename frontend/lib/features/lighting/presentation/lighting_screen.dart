// lib/features/lighting/presentation/lighting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/luma_card.dart';
import '../../../core/widgets/segmented_intensity_bar.dart';
import '../application/lighting_controller.dart';
import '../domain/light_channel.dart';
import '../domain/yacht_light_image.dart';
import 'widgets/rename_light_sheet.dart';

/// AYDINLATMA SİSTEMİ — same underlying logic as the old ESP32-parity
/// Lighting page (6 PWM channels + dimmer), just 4 channels this time,
/// a grid of square press-to-toggle tiles instead of a list+switch, and
/// the segmented bottom-up dimmer instead of a flat slider. The yacht
/// photo sits center-stage and swaps live as lights toggle, so the
/// operator sees the effect of every press immediately.
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
                    width: 280,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1,
                      children: [
                        for (final channel in channels)
                          _LightTile(
                            channel: channel,
                            isSelected: channel.ledNumber == _selectedLed,
                            onTap: () {
                              notifier.toggle(channel.ledNumber);
                              setState(() => _selectedLed = channel.ledNumber);
                            },
                            onRename: () => showRenameLightSheet(context, channel.ledNumber, channel.name),
                          ),
                      ],
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
                    width: 220,
                    child: LumaCard(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      child: _ChannelDimmer(
                        channel: selected,
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

/// A big square press-to-toggle tile — press turns the light on, press
/// again turns it off; no separate switch control. A small pencil in
/// the corner opens the rename sheet without triggering the toggle.
class _LightTile extends StatelessWidget {
  const _LightTile({
    required this.channel,
    required this.isSelected,
    required this.onTap,
    required this.onRename,
  });

  final LightChannel channel;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final color = channel.isOn ? AppColors.success : AppColors.textTertiary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: channel.isOn ? AppColors.success.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? AppColors.accent
                  : (channel.isOn ? AppColors.success.withValues(alpha: 0.5) : AppColors.hairline),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: channel.isOn
                ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.22), blurRadius: 20, spreadRadius: 1)]
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: onRename,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.edit_outlined, size: 15, color: AppColors.textTertiary),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      channel.isOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                      size: 34,
                      color: color,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        channel.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: channel.isOn ? Colors.white : AppColors.textSecondary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      channel.isOn ? 'AÇIK' : 'KAPALI',
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChannelDimmer extends StatelessWidget {
  const _ChannelDimmer({required this.channel, required this.onBrightness});

  final LightChannel channel;
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
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
        const SizedBox(height: 6),
        Text('PARLAKLIK', style: TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(
          '%${(channel.brightness / 10).round()}',
          style: TextStyle(
            color: channel.isOn ? Colors.white : AppColors.textTertiary,
            fontSize: 28,
            fontWeight: FontWeight.w200,
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: SegmentedIntensityBar(
            value: channel.brightness,
            enabled: channel.isOn,
            onChanged: onBrightness,
            width: 64,
          ),
        ),
      ],
    );
  }
}
