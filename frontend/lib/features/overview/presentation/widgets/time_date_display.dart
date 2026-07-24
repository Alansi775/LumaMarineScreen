import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/overview_providers.dart';

/// The Overview screen's sole hero content — no batteries, no pressure,
/// just time and date (manager's direction: their real project has
/// neither, and this screen should stay simple). Each digit flips like
/// a mechanical split-flap clock and briefly flashes accent-colored the
/// moment it changes, so the minute tick reads as a small event instead
/// of a silent redraw.
class TimeDateDisplay extends ConsumerWidget {
  const TimeDateDisplay({super.key});

  static const _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
    'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];
  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockTickProvider).valueOrNull ?? DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final date =
        '${_weekdays[now.weekday - 1]} · ${now.day} ${_months[now.month - 1]}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FlipDigit(hh[0]),
            _FlipDigit(hh[1]),
            const _ClockColon(),
            _FlipDigit(mm[0]),
            _FlipDigit(mm[1]),
          ],
        ),
        const SizedBox(height: 16),
        Text(date, style: AppTextStyles.sectionLabel.copyWith(fontSize: 20, letterSpacing: 4)),
      ],
    );
  }
}

class _ClockColon extends StatelessWidget {
  const _ClockColon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(':', style: AppTextStyles.displayNumeral.copyWith(fontSize: 140)),
    );
  }
}

/// A single digit that flips on a horizontal hinge when its value
/// changes, and washes from the accent color back to white as it
/// settles — a fresh [TweenAnimationBuilder] is mounted every time the
/// value changes (it shares the same [ValueKey] as the outer
/// [AnimatedSwitcher] transition), so the color wash restarts exactly
/// in sync with the flip.
class _FlipDigit extends StatelessWidget {
  const _FlipDigit(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, child) {
              final angle = (1 - animation.value) * (math.pi / 2.2);
              return Opacity(
                opacity: animation.value.clamp(0.0, 1.0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(angle),
                  child: child,
                ),
              );
            },
          );
        },
        child: TweenAnimationBuilder<Color?>(
          key: ValueKey(value),
          tween: ColorTween(begin: AppColors.accent, end: Colors.white),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          builder: (context, color, _) {
            return Text(
              value,
              style: AppTextStyles.displayNumeral.copyWith(fontSize: 140, color: color),
            );
          },
        ),
      ),
    );
  }
}
