/// One of 6 toilet/pump PWM channels. Uses the ESP32 project's legacy
/// fixed-ID protocol (usrToiletPage.c), not the newer dynamic-node one.
class ToiletChannel {
  const ToiletChannel({
    required this.id,
    required this.name,
    this.isOn = false,
    this.pwmValue = 0,
  });

  final String id;
  final String name;
  final bool isOn;

  /// 0-1000, matches the ESP32 slider range.
  final int pwmValue;

  ToiletChannel copyWith({bool? isOn, int? pwmValue}) {
    return ToiletChannel(
      id: id,
      name: name,
      isOn: isOn ?? this.isOn,
      pwmValue: pwmValue ?? this.pwmValue,
    );
  }
}
