import 'package:flutter/painting.dart';

/// Central color palette. Near-black base with layered surface elevation —
/// never pure flat black, never default Material colors.
class AppColors {
  const AppColors._();

  // Base / elevation
  static const Color background = Color(0xFF060708);
  static const Color surface = Color(0xFF121316);
  static const Color surfaceRaised = Color(0xFF1A1C20);
  static const Color surfaceHighlight = Color(0xFF24272C);
  static const Color hairline = Color(0xFF2A2D33);

  // Text
  static const Color textPrimary = Color(0xFFF5F6F7);
  static const Color textSecondary = Color(0xFFA0A5AD);
  static const Color textTertiary = Color(0xFF6B7078);

  // Primary accent — cool cyan
  static const Color accent = Color(0xFF3FD7E8);
  static const Color accentDim = Color(0xFF1E8A96);
  static const Color accentGlow = Color(0x553FD7E8);

  // Status palette (used sparingly, per data domain)
  static const Color water = Color(0xFF3FD7C7);
  static const Color fuel = Color(0xFFF2A65A);
  static const Color waste = Color(0xFFE5555F);
  static const Color solar = Color(0xFF5B8CFF);
  static const Color warning = Color(0xFFE5555F);
  static const Color success = Color(0xFF52D97F);

  // Gauge track (the unfilled portion of any gauge)
  static const Color gaugeTrack = Color(0xFF232529);

  static const List<Color> accentGradient = [
    Color(0xFF3FD7E8),
    Color(0xFF3F8CE8),
  ];
}
