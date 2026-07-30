import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock_tick_provider.g.dart';

/// Ticks once a second so any on-screen clock (top bar, footer) stays
/// live without rebuilding anything else.
@riverpod
Stream<DateTime> clockTick(ClockTickRef ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}
