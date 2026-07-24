import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_keyboard.dart';
import 'keyboard_target.dart';

/// Wraps the whole app once (in main.dart) and slides the on-screen
/// keyboard up from the bottom whenever any [AppTextField] is tapped,
/// sliding it away on "Done" — this device has no system IME to do
/// this for us.
class KeyboardHost extends ConsumerWidget {
  const KeyboardHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(keyboardTargetProvider);

    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            offset: target == null ? const Offset(0, 1) : Offset.zero,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: target == null ? 0 : 1,
              child: target == null
                  ? const SizedBox.shrink()
                  : AppKeyboard(key: ValueKey(target), controller: target),
            ),
          ),
        ),
      ],
    );
  }
}
