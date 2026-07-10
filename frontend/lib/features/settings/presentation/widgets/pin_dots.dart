import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Row of filled/empty dots showing how many of the 6 PIN digits have
/// been entered so far.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.length, this.digitCount = 6});

  final int length;
  final int digitCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < digitCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < length ? AppColors.accent : Colors.transparent,
                border: Border.all(
                  color: i < length ? AppColors.accent : AppColors.hairline,
                  width: 1.5,
                ),
                boxShadow: i < length
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
