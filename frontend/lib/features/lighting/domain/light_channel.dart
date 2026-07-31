/// One of the LED board's 4 wired channels (of the 6 it electrically
/// supports — `led#` 1-4 map to PB3-PB6 on the real board; 5-6 are
/// unused on this yacht). `led#` never changes (it's the physical wire),
/// `name` is fully user-editable.
class LightChannel {
  const LightChannel({
    required this.ledNumber,
    required this.name,
    this.isOn = false,
    this.brightness = 1000,
  });

  final int ledNumber;
  final String name;
  final bool isOn;

  /// 0-1000 scale, matches the firmware's brightness command exactly
  /// (divided by 10 internally on the board → 0-100%).
  final int brightness;

  LightChannel copyWith({String? name, bool? isOn, int? brightness}) {
    return LightChannel(
      ledNumber: ledNumber,
      name: name ?? this.name,
      isOn: isOn ?? this.isOn,
      brightness: brightness ?? this.brightness,
    );
  }
}
