import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable radial percentage gauge (battery-style). A swept arc, not a
/// full ring — reads as an instrument, not a stock CircularProgressIndicator.
class CircularGauge extends StatelessWidget {
  const CircularGauge({
    super.key,
    required this.value,
    required this.size,
    this.color = AppColors.accent,
    this.strokeWidth = 14,
    this.centerLabel,
    this.centerSublabel,
    this.startAngleDeg = 140,
    this.sweepAngleDeg = 260,
  });

  /// 0.0–1.0
  final double value;
  final double size;
  final Color color;
  final double strokeWidth;
  final Widget? centerLabel;
  final Widget? centerSublabel;
  final double startAngleDeg;
  final double sweepAngleDeg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GaugePainter(
              value: value.clamp(0, 1),
              color: color,
              strokeWidth: strokeWidth,
              startAngleDeg: startAngleDeg,
              sweepAngleDeg: sweepAngleDeg,
            ),
          ),
          if (centerLabel != null || centerSublabel != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?centerLabel,
                if (centerSublabel != null) ...[
                  const SizedBox(height: 4),
                  centerSublabel!,
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
    required this.startAngleDeg,
    required this.sweepAngleDeg,
  });

  final double value;
  final Color color;
  final double strokeWidth;
  final double startAngleDeg;
  final double sweepAngleDeg;

  static const double _tau = 2 * math.pi;

  double _deg(double d) => d * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = AppColors.gaugeTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      _deg(startAngleDeg),
      _deg(sweepAngleDeg),
      false,
      trackPaint,
    );

    if (value <= 0) return;

    final sweep = _deg(sweepAngleDeg) * value;

    final glowPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: _tau,
        transform: GradientRotation(_deg(startAngleDeg)),
        colors: [color.withValues(alpha: 0.35), color],
        stops: const [0, 1],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(rect, _deg(startAngleDeg), sweep, false, glowPaint);

    final valuePaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: _tau,
        transform: GradientRotation(_deg(startAngleDeg)),
        colors: [color.withValues(alpha: 0.55), color],
        stops: const [0, 1],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _deg(startAngleDeg), sweep, false, valuePaint);

    // Bright tip dot for a precise "instrument needle" feel.
    final tipAngle = _deg(startAngleDeg) + sweep;
    final tipCenter = Offset(
      center.dx + radius * math.cos(tipAngle),
      center.dy + radius * math.sin(tipAngle),
    );
    final tipPaint = Paint()..color = Colors.white;
    canvas.drawCircle(tipCenter, strokeWidth * 0.32, tipPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Convenience preset matching AppTextStyles for the common "big % + label"
/// composition used on Overview/Batteries.
class CircularGaugeReading extends StatelessWidget {
  const CircularGaugeReading({
    super.key,
    required this.value,
    required this.percentText,
    required this.label,
    this.size = 220,
    this.color = AppColors.accent,
  });

  final double value;
  final String percentText;
  final String label;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircularGauge(
      value: value,
      size: size,
      color: color,
      centerLabel: Text(percentText, style: AppTextStyles.displayNumeral),
      centerSublabel: Text(label, style: AppTextStyles.sectionLabel),
    );
  }
}
