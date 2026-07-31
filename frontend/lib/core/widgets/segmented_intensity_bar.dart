import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A vertical segmented brightness indicator — segments light up from
/// the bottom, glowing when active, with the boundary segment filling
/// proportionally (not snapping fully on/off) so e.g. 96% reads as
/// "almost full" rather than jumping straight to 100%. Drag anywhere on
/// it to set brightness (0-1000). Sizes to whatever its parent gives it
/// (pass a fixed [width]/[height], or let it fill an `Expanded`) — drag
/// math always uses the actual rendered box, not a guessed constant.
class SegmentedIntensityBar extends StatelessWidget {
  const SegmentedIntensityBar({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.segmentCount = 10,
    this.width = 56,
    this.height = 260,
  });

  /// 0-1000
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;
  final int segmentCount;
  final double width;
  final double height;

  void _handleDrag(Offset localPosition, double actualHeight) {
    if (!enabled || actualHeight <= 0) return;
    final fraction = (1 - (localPosition.dy / actualHeight)).clamp(0.0, 1.0);
    onChanged((fraction * 1000).round());
  }

  @override
  Widget build(BuildContext context) {
    final exactPosition = (value / 1000) * segmentCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedHeight = constraints.hasBoundedHeight ? constraints.maxHeight : height;
        return GestureDetector(
          onPanDown: (d) => _handleDrag(d.localPosition, resolvedHeight),
          onPanUpdate: (d) => _handleDrag(d.localPosition, resolvedHeight),
          child: SizedBox(
            width: width,
            height: constraints.hasBoundedHeight ? double.infinity : height,
            child: Column(
              children: [
                for (var i = segmentCount - 1; i >= 0; i--) ...[
                  Expanded(
                    child: _Segment(fill: enabled ? (exactPosition - i).clamp(0.0, 1.0) : 0.0),
                  ),
                  if (i != 0) const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.fill});

  /// 0.0-1.0 — how much of this segment is lit, bottom-up.
  final double fill;

  @override
  Widget build(BuildContext context) {
    final active = fill > 0;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.gaugeTrack,
        borderRadius: BorderRadius.circular(5),
        boxShadow: active
            ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 8)]
            : null,
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 120),
        tween: Tween(begin: fill, end: fill),
        builder: (context, animatedFill, child) => FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: animatedFill,
          widthFactor: 1,
          child: child,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
