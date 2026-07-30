// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generatorControllerHash() =>
    r'343b8b008ced56ce7853c8c4d3fa971525a7fd47';

/// JENERATÖRLER — reference design shows AC Volt/Hz/kW; confirmed with
/// client that current hardware is DC-only, so this shows DC volt+amp
/// instead. Mock-backed until real telemetry is wired in.
///
/// Copied from [GeneratorController].
@ProviderFor(GeneratorController)
final generatorControllerProvider =
    AutoDisposeNotifierProvider<GeneratorController, GeneratorState>.internal(
      GeneratorController.new,
      name: r'generatorControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generatorControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GeneratorController = AutoDisposeNotifier<GeneratorState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
