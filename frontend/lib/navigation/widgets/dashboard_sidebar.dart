import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../app_section.dart';

/// Fixed-width, full-height left sidebar — the app's real navigation
/// now that swipe/PageView is gone. A vertical list of sections, one
/// highlighted active, with a compass rose + certification mark pinned
/// to the bottom exactly like the reference SCADA design.
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key, required this.current, required this.onSelect});

  final AppSection current;
  final ValueChanged<AppSection> onSelect;

  static const double width = 220;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final section in AppSection.values)
                  _SidebarItem(
                    section: section,
                    active: section == current,
                    onTap: () => onSelect(section),
                  ),
              ],
            ),
          ),
          const _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.section, required this.active, required this.onTap});

  final AppSection section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: active ? AppColors.accent.withValues(alpha: 0.16) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              border: Border.all(
                color: active ? AppColors.accent.withValues(alpha: 0.5) : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  section.icon,
                  size: 20,
                  color: active ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    section.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        children: [
          const Divider(color: AppColors.hairline, height: 1),
          const SizedBox(height: 16),
          Icon(Icons.explore_outlined, size: 36, color: AppColors.accent.withValues(alpha: 0.6)),
          const SizedBox(height: 10),
          Text(
            AppStrings.certCodePlaceholder,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textTertiary, fontSize: 9, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textTertiary),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              AppStrings.ceMark,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
