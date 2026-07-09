import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// The single card surface used across every screen — subtle elevation via
/// a lighter fill + hairline border, never a stock Material shadow.
class LumaCard extends StatelessWidget {
  const LumaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = AppDimensions.radiusLarge,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceRaised.withValues(alpha: 0.6),
            AppColors.surface,
          ],
        ),
      ),
      child: child,
    );
  }
}
