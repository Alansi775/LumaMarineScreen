/// Command bytes and node IDs mirrored from the ESP32 master control unit
/// reference project (`usrLightingPage.c`, `usrSocketsPage.c`,
/// `usrBigRelayPage.h`, `usrToiletPage.c`, `usrShuntPage.h`,
/// `usrCanDynamicIDMaster.h`). Keep these in sync if that protocol changes.
class CanProtocol {
  const CanProtocol._();

  // Real nodes get their CAN ID dynamically (0x300–0x38F) via a
  // request/assign handshake with a CAN master — see
  // usrCanDynamicIDMaster.c on the ESP32 side. That negotiation isn't
  // implemented here yet, so these are fixed placeholder targets until it
  // is; swap in the real assigned ID once the handshake lands.
  static const ledNodeId = 0x301; // Lighting Control (6ch)
  static const socketsRelayNodeId = 0x302; // Sockets Control (6ch) — matches their page 1:1
  static const extraRelayNodeId = 0x303; // Our own additions (TV, Doors) — not part of their spec
  static const bigRelayNodeId = 0x304; // Big Relay Control (16ch, with feedback)
  static const bigShuntNodeId = 0x305; // Shunt Monitor's 2 relay outputs

  static const ledCmdToggle = 0x10;
  static const ledCmdSet = 0x11;
  static const ledCmdSetBrightness = 0x12;

  static const relayCmdToggle = 0x20;
  static const relayCmdSet = 0x21;

  // Big Relay (usrBigRelayPage.h)
  static const bigRelayCmdSetOutput = 0x30;
  static const bigRelayCmdToggleOutput = 0x31;
  static const bigRelayCmdSetAll = 0x32;
  static const bigRelayCmdGetStatus = 0x33;
  static const bigRelayCmdSetAutoPair = 0x34;
  static const bigRelayCmdSetPairMask = 0x35;
  static const bigRelayChannelCount = 16;

  // Big Shunt relay control (usrShuntPage.h) — data[1]=relay 1-2, data[2]=0/1
  static const bigShuntCmdSetRelay = 0x43;

  // Toilet Control (usrToiletPage.c) — legacy fixed-ID protocol, predates
  // the dynamic-node system. Values sent via sendCanHeader: a 32-bit
  // big-endian value in an 8-byte frame, not a [cmd, channel, ...] frame.
  static const toiletButtonBaseId = 0x400; // 0x400-0x405, one per channel
  static const toiletSliderBaseId = 0x406; // 0x406-0x40B, one per channel
}
