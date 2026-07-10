/// One channel of the 16-channel Big Relay card. Unlike the simple
/// LED/Sockets relays, this card reports real input feedback alongside
/// the output it drives (see BIG_RELAY_EVT_INPUT_CHANGED in the ESP32
/// reference project) — [inputOn] models that feedback.
class BigRelayChannel {
  const BigRelayChannel({
    required this.index,
    this.outputOn = false,
    this.inputOn = false,
  });

  /// 0-based position; CAN channel is index+1.
  final int index;
  final bool outputOn;
  final bool inputOn;

  BigRelayChannel copyWith({bool? outputOn, bool? inputOn}) {
    return BigRelayChannel(
      index: index,
      outputOn: outputOn ?? this.outputOn,
      inputOn: inputOn ?? this.inputOn,
    );
  }
}

class BigRelayState {
  const BigRelayState({required this.channels, this.autoPairEnabled = false});

  final List<BigRelayChannel> channels;

  /// When enabled, each output automatically follows its paired input
  /// (BIG_RELAY_CMD_SET_AUTO_PAIR) — real hardware behavior, UI-only stub
  /// here since there's no physical input feed yet.
  final bool autoPairEnabled;

  BigRelayState copyWith({List<BigRelayChannel>? channels, bool? autoPairEnabled}) {
    return BigRelayState(
      channels: channels ?? this.channels,
      autoPairEnabled: autoPairEnabled ?? this.autoPairEnabled,
    );
  }
}
