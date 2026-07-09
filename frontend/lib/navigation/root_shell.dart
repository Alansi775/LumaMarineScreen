import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/widgets/luma_page_indicator.dart';
import 'app_screens.dart';

/// Hosts the horizontal swipe PageView between top-level screens plus the
/// fixed bottom-center dot indicator. No AppBar, no BottomNavigationBar —
/// this is a kiosk canvas, not a phone app.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late final PageController _pageController;
  double _page = 0;

  static final _screens = AppScreen.values;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() => _page = _pageController.page ?? 0);
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: [
              for (final screen in _screens) screen.build(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppDimensions.dotIndicatorBottomOffset,
            child: Center(
              child: LumaPageIndicator(
                count: _screens.length,
                index: _page,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
