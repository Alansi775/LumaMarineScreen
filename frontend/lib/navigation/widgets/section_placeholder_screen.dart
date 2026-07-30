import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../app_section.dart';

/// Shown for every sidebar section except Ana Ekran — full content for
/// these comes later; this just proves the navigation shell is wired
/// end-to-end.
class SectionPlaceholderScreen extends StatelessWidget {
  const SectionPlaceholderScreen({super.key, required this.section});

  final AppSection section;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hairline),
            ),
            child: Icon(section.icon, size: 36, color: AppColors.accent),
          ),
          const SizedBox(height: 20),
          Text(
            section.label,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.yakindaGeliyor,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12, letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}
