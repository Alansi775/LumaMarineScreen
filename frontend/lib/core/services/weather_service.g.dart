// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherHash() => r'517c094ac44023798d5acd5f6d2223d6910eff8c';

/// Fetches live weather every 10 minutes via Open-Meteo (no API key
/// required) for the fixed Istanbul location. Errors surface as a null
/// value so the UI can show its own "no data" treatment rather than
/// crash the dashboard over a flaky network call.
///
/// Copied from [weather].
@ProviderFor(weather)
final weatherProvider = AutoDisposeStreamProvider<WeatherReading?>.internal(
  weather,
  name: r'weatherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherRef = AutoDisposeStreamProviderRef<WeatherReading?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
