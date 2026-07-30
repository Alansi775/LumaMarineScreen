import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// The single panel surface used across every dashboard screen — a flat
/// navy-tinted surface with a thin hairline border, matching the SCADA
/// reference design's instrument-panel look. No blur: this dashboard
/// packs many panels on screen at once, and backdrop blur repeated a
/// dozen+ times per frame is real cost for no visual benefit at this
/// density.
class LumaCard extends StatelessWidget {
  const LumaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = AppDimensions.radiusMedium,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.hairline),
      ),
      child: child,
    );
  }
}
