import 'dart:ui';

/// Fixed kiosk canvas. Confirmed via SSH against the physical device
/// (`/sys/class/graphics/fb0/virtual_size`) — do not derive from MediaQuery.
class AppDimensions {
  const AppDimensions._();

  static const Size canvasSize = Size(1280, 800);

  static const double pagePadding = 32;
  static const double gutter = 20;

  /// Horizontal clearance every full-width screen keeps from both edges
  /// so its content never sits under the floating left/right nav arrows
  /// (68px circles centered at x=10 / right:10 in [RootShell]).
  static const double navArrowGutter = 84;

  static const double radiusSmall = 12;
  static const double radiusMedium = 20;
  static const double radiusLarge = 28;

  static const double borderWidthHairline = 1;

  static const double dotIndicatorSize = 6;
  static const double dotIndicatorSizeActive = 22;
  static const double dotIndicatorGap = 10;
  static const double dotIndicatorBottomOffset = 22;
}
