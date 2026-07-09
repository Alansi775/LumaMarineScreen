import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Reusable vertical fill-bar gauge (tank / temperature style). The fill
/// rises from the bottom with a soft gradient + top glow — reads as a
/// physical level indicator, not a generic LinearProgressIndicator.
class VerticalBarGauge extends StatelessWidget {
  const VerticalBarGauge({
    super.key,
    required this.value,
    required this.color,
    this.width = 46,
    this.height = 180,
    this.trackColor = AppColors.gaugeTrack,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  /// 0.0–1.0. Changes to this value animate smoothly — a live sensor
  /// reading drips down/fills up rather than snapping.
  final double value;
  final Color color;
  final double width;
  final double height;
  final Color trackColor;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.hairline),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: clamped, end: clamped),
        duration: animationDuration,
        curve: Curves.easeInOutCubic,
        builder: (context, animatedValue, _) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: animatedValue == 0 ? 0.02 : animatedValue,
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withValues(alpha: 0.65), color],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.45),
                      blurRadius: 16,
                      spreadRadius: -2,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Composed column: label, bar gauge, and value readout — the common unit
/// repeated across Tanks / Temperatures screens.
class VerticalBarGaugeColumn extends StatelessWidget {
  const VerticalBarGaugeColumn({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.valueText,
    this.subText,
    this.barWidth = 46,
    this.barHeight = 180,
  });

  final String label;
  final double value;
  final Color color;
  final String valueText;
  final String? subText;
  final double barWidth;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(valueText, style: AppTextStyles.cardNumeral.copyWith(color: color)),
        if (subText != null) ...[
          const SizedBox(height: 2),
          Text(subText!, style: AppTextStyles.caption),
        ],
        const SizedBox(height: 14),
        VerticalBarGauge(
          value: value,
          color: color,
          width: barWidth,
          height: barHeight,
        ),
        const SizedBox(height: 14),
        Text(label, style: AppTextStyles.sectionLabel, textAlign: TextAlign.center),
      ],
    );
  }
}
