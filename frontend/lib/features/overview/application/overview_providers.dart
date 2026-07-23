import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overview_providers.g.dart';

/// Ticks once a second so the on-screen clock stays live without rebuilding
/// anything else.
@riverpod
Stream<DateTime> clockTick(ClockTickRef ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}
