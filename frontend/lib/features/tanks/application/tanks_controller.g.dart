// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tanks_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tanksControllerHash() => r'980425d3085d463274e987ea951e34cba8a9a14c';

/// Two rows of 3 generic tanks (T1-T3), one per resistive sensor type —
/// matches the real Tank Level page's row grouping, just 3 columns
/// instead of their 4. TEST_MODE toggle mirrors theirs exactly: REAL
/// (default) waits for real sensor data, TEST animates plausible values.
///
/// Copied from [TanksController].
@ProviderFor(TanksController)
final tanksControllerProvider =
    AutoDisposeNotifierProvider<TanksController, TanksState>.internal(
      TanksController.new,
      name: r'tanksControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tanksControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TanksController = AutoDisposeNotifier<TanksState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
