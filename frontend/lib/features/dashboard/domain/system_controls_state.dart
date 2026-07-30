/// Sintine Pompa (bilge pump) is tri-state in the reference design —
/// KAPALI / AÇIK / OTOMATİK — everything else is a plain boolean toggle.
enum SintineMode { kapali, acik, otomatik }

class SystemControlsState {
  const SystemControlsState({
    this.icAydinlatma = false,
    this.disAydinlatma = false,
    this.pompa1 = false,
    this.pompa2 = false,
    this.sintinePompa = SintineMode.kapali,
    this.klima = false,
    this.irgat = false,
    this.horn = false,
  });

  final bool icAydinlatma;
  final bool disAydinlatma;
  final bool pompa1;
  final bool pompa2;
  final SintineMode sintinePompa;
  final bool klima;
  final bool irgat;
  final bool horn;

  SystemControlsState copyWith({
    bool? icAydinlatma,
    bool? disAydinlatma,
    bool? pompa1,
    bool? pompa2,
    SintineMode? sintinePompa,
    bool? klima,
    bool? irgat,
    bool? horn,
  }) {
    return SystemControlsState(
      icAydinlatma: icAydinlatma ?? this.icAydinlatma,
      disAydinlatma: disAydinlatma ?? this.disAydinlatma,
      pompa1: pompa1 ?? this.pompa1,
      pompa2: pompa2 ?? this.pompa2,
      sintinePompa: sintinePompa ?? this.sintinePompa,
      klima: klima ?? this.klima,
      irgat: irgat ?? this.irgat,
      horn: horn ?? this.horn,
    );
  }
}
