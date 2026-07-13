/// Phase 1 has no real CAN hardware attached to this device — every node
/// is genuinely "not connected". This mirrors the ESP32 firmware's own
/// behavior exactly: it checks `getNodeIDByType(...) == 0` before sending
/// anything and rejects the action with a status message ("LED kartı
/// bağlı değil", "Big relay node not connected", etc. — see
/// usrLightingPage.c/usrSocketsPage.c/usrBigRelayPage.c) rather than
/// pretending the command went anywhere.
///
/// Flip these to real values once the dynamic ID handshake
/// (usrCanDynamicIDMaster.c) is implemented and a node has actually
/// confirmed its assigned CAN ID.
class NodeConnection {
  const NodeConnection._();

  static const ledNodeConnected = false;
  static const socketsRelayNodeConnected = false;
  static const bigRelayNodeConnected = false;
  static const bigShuntNodeConnected = false;
}
