// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$environmentRepositoryHash() =>
    r'ae9247388e3b22f74a0c2b84bbc14f12b0303376';

/// See also [environmentRepository].
@ProviderFor(environmentRepository)
final environmentRepositoryProvider =
    AutoDisposeProvider<EnvironmentRepository>.internal(
      environmentRepository,
      name: r'environmentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$environmentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvironmentRepositoryRef =
    AutoDisposeProviderRef<EnvironmentRepository>;
String _$environmentHash() => r'b48404f53076918cfe30f8774dea5b9dcbc600b2';

/// See also [environment].
@ProviderFor(environment)
final environmentProvider =
    AutoDisposeStreamProvider<EnvironmentReading>.internal(
      environment,
      name: r'environmentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$environmentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvironmentRef = AutoDisposeStreamProviderRef<EnvironmentReading>;
String _$clockTickHash() => r'100e5a521226b2e81337f951514cfed96013afbd';

/// Ticks once a second so the on-screen clock stays live without rebuilding
/// anything else.
///
/// Copied from [clockTick].
@ProviderFor(clockTick)
final clockTickProvider = AutoDisposeStreamProvider<DateTime>.internal(
  clockTick,
  name: r'clockTickProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clockTickHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClockTickRef = AutoDisposeStreamProviderRef<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
