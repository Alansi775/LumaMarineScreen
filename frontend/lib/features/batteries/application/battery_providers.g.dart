// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$batteryRepositoryHash() => r'168de900178df7c0ba52fb324aebcfeafa29d063';

/// See also [batteryRepository].
@ProviderFor(batteryRepository)
final batteryRepositoryProvider =
    AutoDisposeProvider<BatteryRepository>.internal(
      batteryRepository,
      name: r'batteryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$batteryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BatteryRepositoryRef = AutoDisposeProviderRef<BatteryRepository>;
String _$mainBatteryHash() => r'26db43416ceb012190bdd9d634e64dd9e0971e77';

/// See also [mainBattery].
@ProviderFor(mainBattery)
final mainBatteryProvider = AutoDisposeStreamProvider<BatteryModel>.internal(
  mainBattery,
  name: r'mainBatteryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainBatteryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainBatteryRef = AutoDisposeStreamProviderRef<BatteryModel>;
String _$backupBatteryHash() => r'a9e249893e1d5069a45517fc463d05f8f6b316e6';

/// See also [backupBattery].
@ProviderFor(backupBattery)
final backupBatteryProvider = AutoDisposeStreamProvider<BatteryModel>.internal(
  backupBattery,
  name: r'backupBatteryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupBatteryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackupBatteryRef = AutoDisposeStreamProviderRef<BatteryModel>;
String _$batteryCircuitsHash() => r'b6968f52ef0d9c51d2dc07d3bc2ae1ff6ecb177d';

/// See also [batteryCircuits].
@ProviderFor(batteryCircuits)
final batteryCircuitsProvider =
    AutoDisposeStreamProvider<List<CircuitModel>>.internal(
      batteryCircuits,
      name: r'batteryCircuitsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$batteryCircuitsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BatteryCircuitsRef = AutoDisposeStreamProviderRef<List<CircuitModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
