import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/alarm_entry.dart';

part 'alarm_list_controller.g.dart';

/// AKTİF ALARMLAR — static mock entries for now. "TÜM ALARMLARI GÖR" is
/// a non-functional placeholder button; real alarm sourcing plugs in
/// here later without changing the panel widget.
@riverpod
List<AlarmEntry> alarmList(AlarmListRef ref) {
  return const [
    AlarmEntry(
      severity: AlarmSeverity.warning,
      time: '14:32',
      message: 'Sintine seviyesi yüksek',
      location: 'MAKİNE DAİRESİ',
    ),
    AlarmEntry(
      severity: AlarmSeverity.critical,
      time: '13:57',
      message: 'İskele motor sıcaklığı yüksek',
      location: 'MAKİNE DAİRESİ',
    ),
    AlarmEntry(
      severity: AlarmSeverity.warning,
      time: '11:20',
      message: 'Akü bankası düşük voltaj',
      location: 'ELEKTRİK SİSTEMİ',
    ),
  ];
}
