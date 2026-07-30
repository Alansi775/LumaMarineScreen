import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_bus_service.g.dart';

/// One inbound reading, keyed by CAN id — mirrors how a real frame off
/// the bus would be keyed once hardware exists.
class DashboardFrame {
  const DashboardFrame({required this.canId, required this.payload});

  final int canId;
  final Object? payload;
}

/// Generic bus abstraction for the new SCADA dashboard — deliberately
/// separate from [CanBusService] in `core/canbus/`, which speaks the
/// real, already-flashed ESP32 protocol (exact node ids/command bytes,
/// never to be touched). This one is for the dashboard's own new
/// commands (system control toggles) and readings (engine/generator/
/// electrical/tank telemetry) that don't have a confirmed real byte
/// layout yet. Swapping [MockDashboardBusService] for a real
/// implementation later is a one-class change, not a UI rewrite — every
/// dashboard controller only ever talks to this interface.
abstract class DashboardBusService {
  Future<void> sendCommand(int canId, Object? payload);

  /// Inbound readings for one CAN id.
  Stream<DashboardFrame> frames(int canId);
}

/// Logs every sent command to the console and lets callers register a
/// periodic synthetic reading generator per CAN id — believable fake
/// telemetry now, same subscription shape a real bus will satisfy later.
class MockDashboardBusService implements DashboardBusService {
  final _controller = _BroadcastFrames();
  final _mockChannels = <int, _MockChannel>{};

  @override
  Future<void> sendCommand(int canId, Object? payload) async {
    // ignore: avoid_print
    print('[MockDashboardBus] SEND canId=0x${canId.toRadixString(16)} payload=$payload');
  }

  @override
  Stream<DashboardFrame> frames(int canId) {
    return _controller.stream.where((f) => f.canId == canId);
  }

  /// Starts (once) a periodic synthetic reading for [canId], calling
  /// [generate] every [interval] and pushing the result as a frame.
  /// Safe to call every build — only the first call per [canId] starts
  /// a timer.
  void ensureMockChannel(int canId, Object? Function() generate, {Duration interval = const Duration(seconds: 2)}) {
    _mockChannels.putIfAbsent(canId, () {
      final channel = _MockChannel(canId: canId, generate: generate, interval: interval, sink: _controller);
      channel.start();
      return channel;
    });
  }

  void dispose() {
    for (final channel in _mockChannels.values) {
      channel.stop();
    }
    _mockChannels.clear();
    _controller.close();
  }
}

class _BroadcastFrames {
  final _controller = StreamController<DashboardFrame>.broadcast();

  Stream<DashboardFrame> get stream => _controller.stream;

  void add(DashboardFrame frame) => _controller.add(frame);

  void close() => _controller.close();
}

class _MockChannel {
  _MockChannel({
    required this.canId,
    required this.generate,
    required this.interval,
    required this.sink,
  });

  final int canId;
  final Object? Function() generate;
  final Duration interval;
  final _BroadcastFrames sink;
  Timer? _timer;

  void start() {
    sink.add(DashboardFrame(canId: canId, payload: generate()));
    _timer = Timer.periodic(interval, (_) => sink.add(DashboardFrame(canId: canId, payload: generate())));
  }

  void stop() => _timer?.cancel();
}

@Riverpod(keepAlive: true)
MockDashboardBusService dashboardBusService(DashboardBusServiceRef ref) {
  final service = MockDashboardBusService();
  ref.onDispose(service.dispose);
  return service;
}
