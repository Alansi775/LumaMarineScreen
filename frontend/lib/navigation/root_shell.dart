import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/widgets/edge_glow_overlay.dart';
import '../core/widgets/luma_page_indicator.dart';
import 'app_screens.dart';

/// Hosts the horizontal swipe PageView between top-level screens plus the
/// fixed bottom-center dot indicator and left/right nav arrows. No
/// AppBar, no BottomNavigationBar — this is a kiosk canvas, not a phone
/// app, but a tap-to-navigate option sits alongside swiping for anyone
/// who prefers pressing over dragging.
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

  void _goTo(int index) {
    if (index < 0 || index >= _screens.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = _page.round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: EdgeGlowOverlay(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              children: [for (final screen in _screens) screen.build()],
            ),
            if (index > 0)
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavArrowButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _goTo(index - 1),
                  ),
                ),
              ),
            if (index < _screens.length - 1)
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavArrowButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _goTo(index + 1),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppDimensions.dotIndicatorBottomOffset,
              child: Center(
                child: LumaPageIndicator(count: _screens.length, index: _page),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrowButton extends StatefulWidget {
  const _NavArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_NavArrowButton> createState() => _NavArrowButtonState();
}

class _NavArrowButtonState extends State<_NavArrowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.88 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceRaised.withValues(
              alpha: _pressed ? 0.95 : 0.55,
            ),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: _pressed ? 0.7 : 0.25),
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 18,
                    ),
                  ]
                : null,
          ),
          child: Icon(widget.icon, color: AppColors.accent, size: 26),
        ),
      ),
    );
  }
}
