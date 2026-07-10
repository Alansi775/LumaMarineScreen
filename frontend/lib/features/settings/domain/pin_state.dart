/// Session PIN lock state. Matches the ESP32 reference project's
/// setup/entry/change flow (usrGraphicalInterface PAGE_PASSWORD_*), backed
/// by in-memory state for Phase 1 — plugs into real persistence
/// (NVS-equivalent) later without touching UI.
class PinState {
  const PinState({this.pin, this.isVerified = false});

  final String? pin;
  final bool isVerified;

  bool get isSet => pin != null;

  PinState copyWith({String? pin, bool? isVerified}) {
    return PinState(
      pin: pin ?? this.pin,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
