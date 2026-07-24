import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A 3x4 numeric keypad (1-9, blank, 0, backspace) for PIN entry. Purely
/// presentational — the caller owns the entered-digits buffer.
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const _layout = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.3,
        children: [
          for (final key in _layout) _KeypadButton(label: key, onDigit: onDigit, onBackspace: onBackspace),
        ],
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onDigit,
    required this.onBackspace,
  });

  final String label;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: label == '⌫' ? onBackspace : () => onDigit(label),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        alignment: Alignment.center,
        child: label == '⌫'
            ? Icon(Icons.backspace_outlined, size: 20, color: Colors.white.withValues(alpha: 0.6))
            : Text(label, style: AppTextStyles.cardNumeral.copyWith(color: Colors.white)),
      ),
    );
  }
}
