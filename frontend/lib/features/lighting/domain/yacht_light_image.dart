/// lib/features/lighting/domain/yacht_light_image.dart
/// Picks the yacht photo that matches the current floor1/floor2/floor3/
/// water light combination. Only 7 combination photos exist (plus the
/// plain all-off photo) — named by the client so each maps to an exact
/// state; anything not covered falls back to the closest match with
/// water light ignored, then to the plain photo. Ledger of covered
/// states, verified against the actual filenames in assets/images/:
///
/// | floor1 | floor2 | floor3 | water | asset |
/// |---|---|---|---|---|
/// | 0 | 0 | 0 | 0 | yatch.png |
/// | 1 | 0 | 0 | 0 | secondandthirdfloorofffirston |
/// | 0 | 0 | 1 | 0 | alllightsoffexceptfloor3on |
/// | 1 | 1 | 0 | 0 | allfloorsonaccetpthirdflooroff |
/// | 1 | 0 | 1 | 0 | allfloorsonexceptsecondflooroff |
/// | 0 | 1 | 1 | 0 | alllightsonexceptfisrtflooroff |
/// | 1 | 1 | 1 | 0 | allflorson |
/// | 0 | 0 | 0 | 1 | alllightsoffbutwaterlightson |
String yachtImageAssetFor({
  required bool floor1,
  required bool floor2,
  required bool floor3,
  required bool water,
}) {
  final exact = _exactMatches['$floor1$floor2$floor3$water'];
  if (exact != null) return exact;

  // No exact match (e.g. water combined with any floor) — fall back to
  // the closest floor-only combination, ignoring water light.
  final floorOnly = _exactMatches['$floor1$floor2${floor3}false'];
  if (floorOnly != null) return floorOnly;

  return _allOff;
}

const _allOff = 'assets/images/yatch.png';

final _exactMatches = <String, String>{
  'falsefalsefalsefalse': _allOff,
  'truefalsefalsefalse': 'assets/images/secondandthirdfloorofffirston Background Removed.png',
  'falsefalsetruefalse': 'assets/images/alllightsoffexceptfloor3on.png',
  'truetruefalsefalse': 'assets/images/allfloorsonaccetpthirdflooroff Background Removed.png',
  'truefalsetruefalse': 'assets/images/allfloorsonexceptsecondflooroff Background Removed.png',
  'falsetruetruefalse': 'assets/images/alllightsonexceptfisrtflooroff Background Removed.png',
  'truetruetruefalse': 'assets/images/allflorson Background Removed.png',
  'falsefalsefalsetrue': 'assets/images/alllightsoffbutwaterlightson Background Removed.png',
};
