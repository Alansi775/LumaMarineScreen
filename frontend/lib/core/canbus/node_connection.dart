/// Phase 1 has no real CAN hardware attached to this device — every node
/// is genuinely "not connected". Controls still respond immediately when
/// pressed (so the app demos smoothly) and still send/log the real CAN
/// frame, but since no hardware is there to confirm it, the state snaps
/// back after [revertDelay] — a software stand-in for the real firmware's
/// behavior of never actually changing an unconfirmed relay/LED state.
///
/// Flip the `*NodeConnected` flags to real values once the dynamic ID
/// handshake (usrCanDynamicIDMaster.c) is implemented and a node has
/// actually confirmed its assigned CAN ID — at that point the revert
/// timers simply never fire.
class NodeConnection {
  const NodeConnection._();

  static const ledNodeConnected = false;
  static const socketsRelayNodeConnected = false;
  static const bigRelayNodeConnected = false;
  static const bigShuntNodeConnected = false;

  static const revertDelay = Duration(milliseconds: 1500);
}
