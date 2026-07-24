import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A signature ambient touch: a bright, colorful "comet" that travels
/// around the screen's edge, speeding up and slowing down lap to lap,
/// breathing in and out in brightness, and slowly shifting color, with
/// a fading tail and a bright flare at its head — so it unmistakably
/// reads as "something is happening" rather than blending into the
/// border. Purely decorative and non-interactive, imagined for the
/// yacht at night, quietly alive even when no one is touching it.
class EdgeGlowOverlay extends StatefulWidget {
  const EdgeGlowOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<EdgeGlowOverlay> createState() => _EdgeGlowOverlayState();
}

class _EdgeGlowOverlayState extends State<EdgeGlowOverlay> with TickerProviderStateMixin {
  late final AnimationController _lapController;
  late final AnimationController _breatheController;
  final _random = Random();

  static const _colors = [
    AppColors.accent,
    AppColors.solar,
    AppColors.water,
    Color(0xFFB388FF),
    AppColors.fuel,
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _lapController = AnimationController(vsync: this, duration: _randomLapDuration())
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _colorIndex = (_colorIndex + 1) % _colors.length);
          _lapController
            ..duration = _randomLapDuration()
            ..forward(from: 0);
        }
      })
      ..forward();

    _breatheController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3200 + _random.nextInt(2200)),
    )..repeat(reverse: true);
  }

  Duration _randomLapDuration() => Duration(milliseconds: 4500 + _random.nextInt(8500));

  @override
  void dispose() {
    _lapController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: Listenable.merge([_lapController, _breatheController]),
              builder: (context, _) {
                final breathe = 0.45 + 0.55 * Curves.easeInOut.transform(_breatheController.value);
                final nextColor = _colors[(_colorIndex + 1) % _colors.length];
                return CustomPaint(
                  painter: _EdgeGlowPainter(
                    progress: _lapController.value,
                    opacity: breathe,
                    color: _colors[_colorIndex],
                    nextColor: nextColor,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _EdgeGlowPainter extends CustomPainter {
  _EdgeGlowPainter({
    required this.progress,
    required this.opacity,
    required this.color,
    required this.nextColor,
  });

  final double progress;
  final double opacity;
  final Color color;
  final Color nextColor;

  static const double _trailFraction = 0.22;
  static const int _trailSteps = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRect(Offset.zero & size);
    final metric = path.computeMetrics().first;
    final total = metric.length;

    final headDist = progress * total;
    final trailLen = total * _trailFraction;
    final laneColor = Color.lerp(color, nextColor, progress) ?? color;

    // Draw the tail as a series of short segments with increasing
    // opacity toward the head — a real fade along the path, not a flat
    // stroke that just stops.
    for (var step = 0; step < _trailSteps; step++) {
      final t0 = step / _trailSteps;
      final t1 = (step + 1) / _trailSteps;
      final segStart = headDist - trailLen + trailLen * t0;
      final segEnd = headDist - trailLen + trailLen * t1;
      final segAlpha = opacity * t1 * t1;

      final segment = _extractWrapped(metric, segStart, segEnd, total);
      if (segment == null) continue;

      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = laneColor.withValues(alpha: segAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
      canvas.drawPath(segment, glowPaint);
    }

    // The head itself: a tight bright core plus a big soft flare so the
    // moving point is unmistakable even at a glance.
    final headTangent = metric.getTangentForOffset(headDist % total);
    if (headTangent != null) {
      final flarePaint = Paint()
        ..color = laneColor.withValues(alpha: opacity * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
      canvas.drawCircle(headTangent.position, 10, flarePaint);

      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(headTangent.position, 4, corePaint);
    }
  }

  Path? _extractWrapped(PathMetric metric, double start, double end, double total) {
    if (end <= start) return null;
    if (start >= 0) {
      if (start >= total) return null;
      return metric.extractPath(start, end.clamp(0, total));
    }
    // Wraps past the path's start — stitch the tail-end and head-start
    // pieces together so the comet doesn't visibly break at the seam.
    final wrappedStart = total + start;
    final part1 = metric.extractPath(wrappedStart, total);
    final part2 = end > 0 ? metric.extractPath(0, end.clamp(0, total)) : null;
    final combined = Path()..addPath(part1, Offset.zero);
    if (part2 != null) combined.addPath(part2, Offset.zero);
    return combined;
  }

  @override
  bool shouldRepaint(covariant _EdgeGlowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.opacity != opacity ||
        oldDelegate.color != color ||
        oldDelegate.nextColor != nextColor;
  }
}
