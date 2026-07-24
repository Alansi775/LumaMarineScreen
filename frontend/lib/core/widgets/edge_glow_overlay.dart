import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A signature ambient touch: a soft glowing "comet" that travels around
/// the screen's edge, speeding up and slowing down lap to lap, breathing
/// in and out in brightness, and slowly shifting color. Purely
/// decorative and non-interactive — imagined for the yacht at night,
/// quietly alive even when no one is touching it.
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

  static const _colors = [AppColors.accent, AppColors.solar, AppColors.water];
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
      duration: Duration(milliseconds: 5000 + _random.nextInt(4000)),
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
                final breathe = 0.2 + 0.55 * Curves.easeInOut.transform(_breatheController.value);
                return CustomPaint(
                  painter: _EdgeGlowPainter(
                    progress: _lapController.value,
                    opacity: breathe,
                    color: _colors[_colorIndex],
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
  _EdgeGlowPainter({required this.progress, required this.opacity, required this.color});

  final double progress;
  final double opacity;
  final Color color;

  static const double _trailFraction = 0.16;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRect(Offset.zero & size);
    final metric = path.computeMetrics().first;
    final total = metric.length;

    final headDist = progress * total;
    final trailLen = total * _trailFraction;
    final startDist = headDist - trailLen;

    final Path segment;
    if (startDist < 0) {
      final part1 = metric.extractPath(0, headDist);
      final part2 = metric.extractPath(total + startDist, total);
      segment = Path()
        ..addPath(part1, Offset.zero)
        ..addPath(part2, Offset.zero);
    } else {
      segment = metric.extractPath(startDist, headDist);
    }

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(segment, glowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: opacity * 0.75)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(segment, corePaint);
  }

  @override
  bool shouldRepaint(covariant _EdgeGlowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.opacity != opacity ||
        oldDelegate.color != color;
  }
}
