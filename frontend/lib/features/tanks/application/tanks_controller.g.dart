// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tanks_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tanksControllerHash() => r'577e0c410e559b76fb9b8a2b99fab31f4438b9bf';

/// Live tank telemetry + the one write action a captain actually needs:
/// pumping the waste tank out. Fresh water drips down and waste creeps up
/// on a timer to simulate a real level sensor feed — Phase 1 has no
/// hardware yet, but the UI should already feel like it's watching one.
///
/// Copied from [TanksController].
@ProviderFor(TanksController)
final tanksControllerProvider =
    AutoDisposeNotifierProvider<TanksController, List<Tank>>.internal(
      TanksController.new,
      name: r'tanksControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tanksControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TanksController = AutoDisposeNotifier<List<Tank>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
