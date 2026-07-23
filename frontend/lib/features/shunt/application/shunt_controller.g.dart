// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shunt_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shuntControllerHash() => r'738414191166b91d02a04abb2d725ac92d9200e8';

/// Main shunt (300A) + 2 batteries + 4 quadro shunts (30A each) —
/// matches usrShuntPage.c's real data set exactly. TEST_MODE toggle
/// mirrors theirs: REAL (default) shows zeroed/waiting readings, TEST
/// animates plausible values (same seed numbers as their test-mode init).
///
/// Copied from [ShuntController].
@ProviderFor(ShuntController)
final shuntControllerProvider =
    AutoDisposeNotifierProvider<ShuntController, ShuntState>.internal(
      ShuntController.new,
      name: r'shuntControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shuntControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShuntController = AutoDisposeNotifier<ShuntState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
