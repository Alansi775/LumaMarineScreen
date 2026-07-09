// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperatures_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$temperaturesControllerHash() =>
    r'ff3f9f22f763fc5c356dafe203d5c22b8429fcf8';

/// Live temperature readings. Phase 1 has one probe — outside/ambient
/// air — drifting within a realistic range on a timer to simulate a real
/// sensor feed. Adding Freezer/Engine Room/Cabin later is just another
/// seed entry here, no screen changes needed.
///
/// Copied from [TemperaturesController].
@ProviderFor(TemperaturesController)
final temperaturesControllerProvider =
    AutoDisposeNotifierProvider<
      TemperaturesController,
      List<TemperatureSensor>
    >.internal(
      TemperaturesController.new,
      name: r'temperaturesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$temperaturesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TemperaturesController = AutoDisposeNotifier<List<TemperatureSensor>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
