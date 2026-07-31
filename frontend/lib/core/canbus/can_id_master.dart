import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'can_bus_service.dart';
import 'can_bus_transport.dart';
import 'can_frame.dart';
import 'can_protocol.dart';

part 'can_id_master.g.dart';

/// A node (board) this master has assigned a CAN ID to.
class AssignedCanNode {
  const AssignedCanNode({
    required this.uniqueId,
    required this.nodeType,
    required this.offset,
    required this.active,
  });

  final int uniqueId;
  final int nodeType;
  final int offset;

  /// True once the board has confirmed and moved to ACTIVE — only then
  /// does it actually accept LED/relay commands (see
  /// `IS_ID_ASSIGNED()`/`parseIncomingValue` in the firmware).
  final bool active;

  int get assignedId => CanProtocol.dynamicIdMin + offset;

  AssignedCanNode copyWith({bool? active}) => AssignedCanNode(
        uniqueId: uniqueId,
        nodeType: nodeType,
        offset: offset,
        active: active ?? this.active,
      );
}

/// Plays the "master" role in the dynamic CAN ID assignment protocol
/// real boards (LED, relay, sensor nodes) expect at boot — verified
/// against the real STM32 firmware (`LedBoard/Core/Src/usrCan.c`), not
/// guessed. Listens for `CMD_REQUEST_ID` broadcasts, hands out an
/// offset in the board's type-appropriate range, and keeps sending a
/// master heartbeat so already-assigned boards don't time out and
/// restart the handshake.
class CanIdMaster {
  CanIdMaster(this._transport, {this.masterId = 0x4C4D}) {
    _sub = _transport.incoming.listen(_onFrame);
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 3), (_) => _sendMasterHeartbeat());
  }

  final CanBusTransport _transport;

  /// Our own 16-bit identifier as bus master — arbitrary but constant;
  /// boards only use it to notice when a *different* master has taken
  /// over. 0x4C4D = ASCII "LM" (Luma Marine).
  final int masterId;

  final Map<int, AssignedCanNode> _byUniqueId = {};
  int _nextOffset = 1;
  StreamSubscription<CanFrame>? _sub;
  Timer? _heartbeatTimer;

  final _updates = StreamController<AssignedCanNode>.broadcast();

  /// Emits every time a node's assignment changes (newly assigned, or
  /// confirmed ACTIVE).
  Stream<AssignedCanNode> get updates => _updates.stream;

  /// The most recently known assignment for a given node type, if any —
  /// e.g. `nodeFor(CanProtocol.nodeTypeLed)` for the LED board.
  AssignedCanNode? nodeFor(int nodeType) {
    for (final node in _byUniqueId.values) {
      if (node.nodeType == nodeType) return node;
    }
    return null;
  }

  void _onFrame(CanFrame frame) {
    if (frame.id == CanProtocol.canIdRequestId) {
      _handleRequest(frame);
    } else if (frame.id == CanProtocol.canIdAssignmentId) {
      _handleConfirmation(frame);
    }
  }

  void _handleRequest(CanFrame frame) {
    if (frame.data.length < 6 || frame.data[0] != CanProtocol.cmdRequestId) return;

    final uid = _readU32(frame.data, 1);
    final nodeType = frame.data[5];

    final existing = _byUniqueId[uid];
    final offset = existing?.offset ?? _nextOffset++;

    _byUniqueId[uid] = AssignedCanNode(uniqueId: uid, nodeType: nodeType, offset: offset, active: false);

    final payload = <int>[
      CanProtocol.cmdAssignId,
      (uid >> 24) & 0xFF,
      (uid >> 16) & 0xFF,
      (uid >> 8) & 0xFF,
      uid & 0xFF,
      offset,
      (masterId >> 8) & 0xFF,
      masterId & 0xFF,
    ];
    _transport.send(CanFrame(id: CanProtocol.canIdAssignmentId, data: payload));
    _updates.add(_byUniqueId[uid]!);
  }

  void _handleConfirmation(CanFrame frame) {
    if (frame.data.length < 6 || frame.data[0] != CanProtocol.cmdIdConfirmation) return;

    final uid = _readU32(frame.data, 1);
    final node = _byUniqueId[uid];
    if (node == null) return;

    _byUniqueId[uid] = node.copyWith(active: true);
    _updates.add(_byUniqueId[uid]!);
  }

  void _sendMasterHeartbeat() {
    final payload = <int>[CanProtocol.cmdMasterHeartbeat, (masterId >> 8) & 0xFF, masterId & 0xFF];
    _transport.send(CanFrame(id: CanProtocol.canMasterHeartbeatId, data: payload));
  }

  int _readU32(List<int> data, int offset) {
    return (data[offset] << 24) | (data[offset + 1] << 16) | (data[offset + 2] << 8) | data[offset + 3];
  }

  void dispose() {
    _sub?.cancel();
    _heartbeatTimer?.cancel();
    _updates.close();
  }
}

@Riverpod(keepAlive: true)
CanIdMaster canIdMaster(CanIdMasterRef ref) {
  final master = CanIdMaster(ref.watch(canBusTransportProvider));
  ref.onDispose(master.dispose);
  return master;
}
