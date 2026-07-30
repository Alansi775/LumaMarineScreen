import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

/// Thin footer bar present on every section: company name, version,
/// cert code, and a "system running" indicator — global chrome, like
/// the top bar, not something that belongs to just the home screen.
class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  static const double height = 32;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          const Text(
            AppStrings.companyName,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(width: 16),
          Text(AppStrings.versionPlaceholder, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
          const SizedBox(width: 16),
          Text(AppStrings.certCodePlaceholder, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
          const Spacer(),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
              boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.6), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            AppStrings.sistemCalisiyor,
            style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
