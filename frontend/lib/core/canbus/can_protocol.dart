/// Command bytes and node IDs mirrored from the ESP32 master control unit
/// reference project (`usrLightingPage.c`, `usrSocketsPage.c`,
/// `usrCanDynamicIDMaster.h`). Keep these in sync if that protocol changes.
class CanProtocol {
  const CanProtocol._();

  // Real nodes get their CAN ID dynamically (0x300–0x38F) via a
  // request/assign handshake with a CAN master — see
  // usrCanDynamicIDMaster.c on the ESP32 side. That negotiation isn't
  // implemented here yet, so these are fixed placeholder targets until it
  // is; swap in the real assigned ID once the handshake lands.
  static const ledNodeId = 0x301;
  static const relayNodeId = 0x302;

  static const ledCmdToggle = 0x10;
  static const ledCmdSet = 0x11;
  static const ledCmdSetBrightness = 0x12;

  static const relayCmdToggle = 0x20;
  static const relayCmdSet = 0x21;
}
