// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_tick_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clockTickHash() => r'100e5a521226b2e81337f951514cfed96013afbd';

/// Ticks once a second so any on-screen clock (top bar, footer) stays
/// live without rebuilding anything else.
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
