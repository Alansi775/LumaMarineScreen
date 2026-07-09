import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Temporary placeholder for screens not yet built in this phase.
/// Deliberately styled to match the rest of the app rather than looking
/// like scaffolding.
class ComingSoonPlaceholder extends StatelessWidget {
  const ComingSoonPlaceholder({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hairline),
            ),
            child: Icon(icon, size: 32, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Text(label, style: AppTextStyles.sectionLabel),
        ],
      ),
    );
  }
}
