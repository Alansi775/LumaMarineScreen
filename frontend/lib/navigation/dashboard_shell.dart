import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/lighting/presentation/lighting_screen.dart';
import 'app_section.dart';
import 'widgets/dashboard_footer.dart';
import 'widgets/dashboard_sidebar.dart';
import 'widgets/dashboard_top_bar.dart';
import 'widgets/section_placeholder_screen.dart';

/// Fixed top bar + fixed left sidebar + a content area that swaps by
/// section, plus a footer bar — replaces the old swipe/PageView shell
/// entirely. No page-transition animation here on purpose: a quick
/// crossfade between sections is all a dense instrument-panel dashboard
/// like this needs.
class DashboardShell extends ConsumerWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(appSectionControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const DashboardTopBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardSidebar(
                  current: section,
                  onSelect: (s) => ref.read(appSectionControllerProvider.notifier).select(s),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: KeyedSubtree(
                        key: ValueKey(section),
                        child: switch (section) {
                          AppSection.home => const HomeScreen(),
                          AppSection.lighting => const LightingScreen(),
                          _ => SectionPlaceholderScreen(section: section),
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashboardFooter(),
        ],
      ),
    );
  }
}
