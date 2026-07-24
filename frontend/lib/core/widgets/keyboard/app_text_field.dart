import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';
import 'keyboard_target.dart';

/// Standard text input for this app. `readOnly` so the OS never tries to
/// summon a system keyboard (flutter-pi has none) — tapping it opens our
/// own on-screen keyboard bound to [controller] instead.
class AppTextField extends ConsumerWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.numeric = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool numeric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(keyboardTargetProvider) == controller;

    return GestureDetector(
      onTap: () => ref.read(keyboardTargetProvider.notifier).state = controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              border: Border.all(color: isActive ? AppColors.accent : AppColors.hairline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? (hintText ?? '') : controller.text,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: controller.text.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isActive)
                  Container(width: 2, height: 20, color: AppColors.accent),
              ],
            ),
          );
        },
      ),
    );
  }
}
