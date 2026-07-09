import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/environment_repository.dart';
import '../../../data/repositories/mock_environment_repository.dart';
import '../domain/environment_reading.dart';

part 'overview_providers.g.dart';

@riverpod
EnvironmentRepository environmentRepository(EnvironmentRepositoryRef ref) {
  return MockEnvironmentRepository();
}

@riverpod
Stream<EnvironmentReading> environment(EnvironmentRef ref) {
  return ref.watch(environmentRepositoryProvider).watchEnvironment();
}

/// Ticks once a second so the on-screen clock stays live without rebuilding
/// anything else.
@riverpod
Stream<DateTime> clockTick(ClockTickRef ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
}
