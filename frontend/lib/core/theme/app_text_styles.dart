import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type scale. Manrope for a geometric, premium instrument-panel feel.
/// Numerals use tabular figures so live-updating readings never jitter.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    List<FontFeature>? fontFeatures,
  }) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: fontFeatures,
      height: 1.05,
    );
  }

  static const _tabular = [FontFeature.tabularFigures()];

  /// Huge hero readings (main battery %, clock).
  static TextStyle displayNumeral = _base(
    size: 64,
    weight: FontWeight.w800,
    fontFeatures: _tabular,
    letterSpacing: -1.5,
  );

  /// Large readings inside cards (tank %, temp value).
  static TextStyle cardNumeral = _base(
    size: 34,
    weight: FontWeight.w700,
    fontFeatures: _tabular,
    letterSpacing: -0.5,
  );

  /// Mid readings (amp values, list rows).
  static TextStyle numeralMedium = _base(
    size: 20,
    weight: FontWeight.w600,
    fontFeatures: _tabular,
  );

  static TextStyle title = _base(size: 22, weight: FontWeight.w700);

  static TextStyle body = _base(
    size: 15,
    weight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle bodyStrong = _base(size: 15, weight: FontWeight.w700);

  /// Small caps section header, e.g. "BATTERIES".
  static TextStyle sectionLabel = _base(
    size: 12.5,
    weight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 2.2,
  );

  static TextStyle caption = _base(
    size: 12,
    weight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.2,
  );

  static TextStyle unit = _base(
    size: 14,
    weight: FontWeight.w600,
    color: AppColors.textTertiary,
  );
}
