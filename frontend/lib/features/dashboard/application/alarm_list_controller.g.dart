// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alarmListHash() => r'c3fb698b151826be67c707b96c59cd73e41e27e5';

/// AKTİF ALARMLAR — static mock entries for now. "TÜM ALARMLARI GÖR" is
/// a non-functional placeholder button; real alarm sourcing plugs in
/// here later without changing the panel widget.
///
/// Copied from [alarmList].
@ProviderFor(alarmList)
final alarmListProvider = AutoDisposeProvider<List<AlarmEntry>>.internal(
  alarmList,
  name: r'alarmListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$alarmListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlarmListRef = AutoDisposeProviderRef<List<AlarmEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
