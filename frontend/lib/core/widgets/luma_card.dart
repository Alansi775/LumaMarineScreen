import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// The single card surface used across every screen — a soft glass
/// panel (blur + faint white hairline), matches the premium
/// glassmorphism look established on Lighting/Tanks. No hard borders,
/// no flat fills.
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF15161A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
