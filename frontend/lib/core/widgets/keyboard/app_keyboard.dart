import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';
import 'keyboard_target.dart';

/// A compact QWERTY on-screen keyboard — this device has no system IME
/// to fall back on, so this is the only way to type anywhere in the app.
class AppKeyboard extends ConsumerStatefulWidget {
  const AppKeyboard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<AppKeyboard> createState() => _AppKeyboardState();
}

class _AppKeyboardState extends ConsumerState<AppKeyboard> {
  bool _shift = false;
  bool _numeric = false;

  static const _letterRows = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  static const _numberRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['-', '/', ':', ';', '(', ')', '€', '&', '@', '"'],
    ['.', ',', '?', '!', "'"],
  ];

  void _insert(String s) {
    final controller = widget.controller;
    final text = controller.text;
    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);
    final newText = text.replaceRange(selection.start, selection.end, s);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + s.length),
    );
    if (_shift) setState(() => _shift = false);
  }

  void _backspace() {
    final controller = widget.controller;
    final text = controller.text;
    final selection = controller.selection.isValid
        ? controller.selection
        : TextSelection.collapsed(offset: text.length);
    if (selection.start == 0 && selection.end == 0) return;
    final start = selection.start == selection.end ? selection.start - 1 : selection.start;
    final newText = text.replaceRange(start, selection.end, '');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start),
    );
  }

  void _done() {
    ref.read(keyboardTargetProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _numeric ? _numberRows : _letterRows;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in rows) _KeyRow(keys: row, shift: _shift, onKey: _insert),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!_numeric)
                _ActionKey(
                  flex: 2,
                  icon: Icons.arrow_upward_rounded,
                  active: _shift,
                  onTap: () => setState(() => _shift = !_shift),
                ),
              _ActionKey(
                flex: 2,
                label: _numeric ? 'ABC' : '123',
                onTap: () => setState(() => _numeric = !_numeric),
              ),
              _ActionKey(
                flex: 6,
                label: 'space',
                onTap: () => _insert(' '),
              ),
              _ActionKey(
                flex: 2,
                icon: Icons.backspace_outlined,
                onTap: _backspace,
              ),
              _ActionKey(
                flex: 2,
                label: 'Done',
                accent: true,
                onTap: _done,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.keys, required this.shift, required this.onKey});

  final List<String> keys;
  final bool shift;
  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          for (final key in keys) ...[
            Expanded(child: _Key(label: shift ? key.toUpperCase() : key, onTap: () => onKey(shift ? key.toUpperCase() : key))),
            if (key != keys.last) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Text(label, style: AppTextStyles.bodyStrong),
      ),
    );
  }
}

class _ActionKey extends StatelessWidget {
  const _ActionKey({
    required this.flex,
    required this.onTap,
    this.label,
    this.icon,
    this.active = false,
    this.accent = false,
  });

  final int flex;
  final VoidCallback onTap;
  final String? label;
  final IconData? icon;
  final bool active;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final highlighted = active || accent;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted ? AppColors.accent.withValues(alpha: 0.18) : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: highlighted ? AppColors.accent : AppColors.hairline),
            ),
            child: icon != null
                ? Icon(icon, size: 20, color: highlighted ? AppColors.accent : AppColors.textSecondary)
                : Text(
                    label ?? '',
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: highlighted ? AppColors.accent : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
