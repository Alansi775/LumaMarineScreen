/// Command bytes and node IDs mirrored from the ESP32 master control unit
/// reference project (`usrLightingPage.c`, `usrSocketsPage.c`,
/// `usrBigRelayPage.h`, `usrShuntPage.h`, `usrCanDynamicIDMaster.h`). Keep
/// these in sync if that protocol changes. Note: `usrToiletPage.c` exists
/// in that codebase but is never wired into real navigation (confirmed via
/// `usrGraphicalInterface.c`'s `controls_buttons`) — no Toilet protocol here.
class CanProtocol {
  const CanProtocol._();

  // Real nodes get their CAN ID dynamically (0x300–0x38F) via a
  // request/assign handshake with a CAN master — see
  // usrCanDynamicIDMaster.c on the ESP32 side. Our own handshake
  // (CanIdMaster) never completes against the real board (it's already
  // bound to the ESP32 reference screen's master), so we fall back to
  // this fixed ID — confirmed via the real ESP32 debug console
  // (`CANMaster: [1] UID: 0x63F8E43A | CAN: 0x300 | Type: LED | ACTIVE`).
  static const ledNodeId = 0x300; // Lighting Control — confirmed real ID
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

  // ================= Dynamic CAN ID assignment protocol =================
  // Verified against the real STM32 firmware source
  // (LedBoard/Core/Inc/usrCanIDList.h + Core/Src/usrCan.c,
  // MarineSoftware.rar) — not guessed. A board with no fixed ID
  // broadcasts a request on [canIdRequestId] at boot; a bus master (see
  // CanIdMaster) must reply on [canIdAssignmentId] with an offset into
  // [dynamicIdMin]..[dynamicIdMax]. The board then confirms on the same
  // ID and goes ACTIVE. The master must keep sending a heartbeat on
  // [canMasterHeartbeatId] at least every 15s (MASTER_HEARTBEAT_TIMEOUT_MS
  // in firmware) or the board forgets its assignment and starts over.
  static const int canIdRequestId = 0x3FE;
  static const int canIdAssignmentId = 0x3FD;
  static const int canMasterHeartbeatId = 0x3FC;
  static const int canBroadcastId = 0x3FF;
  static const int canHeartbeatBaseId = 0x390;

  static const int dynamicIdMin = 0x300;
  static const int dynamicIdMax = 0x38F;

  static const int cmdRequestId = 0x01;
  static const int cmdAssignId = 0x02;
  static const int cmdIdConfirmation = 0x03;
  static const int cmdHeartbeat = 0x04;
  static const int cmdReassignRequest = 0x05;
  static const int cmdMasterHeartbeat = 0x06;

  // node_type_t (usrCanIDList.h)
  static const int nodeTypeLed = 0x01;
  static const int nodeTypeRelay = 0x02;
  static const int nodeTypeSensor = 0x03;
}
