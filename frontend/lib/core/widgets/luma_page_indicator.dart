import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// Minimal dot-style page indicator. Not a nav bar — six small dots, the
/// active one stretches into a glowing pill. Fixed at bottom-center.
class LumaPageIndicator extends StatelessWidget {
  const LumaPageIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final double index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final distance = (index - i).abs().clamp(0.0, 1.0);
        final activeness = 1 - distance;
        final width = AppDimensions.dotIndicatorSize +
            (AppDimensions.dotIndicatorSizeActive -
                    AppDimensions.dotIndicatorSize) *
                activeness;
        final color = Color.lerp(
          AppColors.textTertiary.withValues(alpha: 0.35),
          AppColors.accent,
          activeness,
        )!;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.dotIndicatorGap / 2,
          ),
          child: Container(
            width: width,
            height: AppDimensions.dotIndicatorSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(
                AppDimensions.dotIndicatorSize / 2,
              ),
              boxShadow: activeness > 0.5
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.5 * activeness),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
