import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The 10-segment vertical brightness indicator unique to the Lighting
/// page — segments light up from the bottom, glowing when active. Drag
/// anywhere on it to set brightness (0-1000). Matches the real
/// `active_segments`/`bg_segments` + hidden slider trick in
/// usrLightingPage.c, minus the LVGL implementation detail.
class SegmentedIntensityBar extends StatelessWidget {
  const SegmentedIntensityBar({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.segmentCount = 10,
    this.width = 64,
    this.height = 320,
  });

  /// 0-1000
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;
  final int segmentCount;
  final double width;
  final double height;

  void _handleDrag(Offset localPosition) {
    if (!enabled) return;
    final fraction = (1 - (localPosition.dy / height)).clamp(0.0, 1.0);
    onChanged((fraction * 1000).round());
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = ((value / 1000) * segmentCount).round();

    return GestureDetector(
      onPanDown: (d) => _handleDrag(d.localPosition),
      onPanUpdate: (d) => _handleDrag(d.localPosition),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            for (var i = segmentCount - 1; i >= 0; i--) ...[
              Expanded(child: _Segment(active: enabled && i < activeCount)),
              if (i != 0) const SizedBox(height: 5),
            ],
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: double.infinity,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.gaugeTrack,
        borderRadius: BorderRadius.circular(6),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.55),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
