/// Placeholder CAN ids for the new SCADA dashboard's commands/readings.
/// These are NOT confirmed real hardware ids — they exist only so
/// [MockDashboardBusService] has something consistent to log/key frames
/// by. Deliberately kept in their own namespace, well away from anything
/// in `core/canbus/can_protocol.dart` (the real, already-flashed ESP32
/// protocol — never touch that file's values). Replace these with the
/// manager's confirmed real ids once this dashboard's hardware mapping
/// is finalized.
class DashboardCanIds {
  const DashboardCanIds._();

  // Outgoing — system control toggles (Sistem Kontrolleri).
  static const int icAydinlatma = 0x900;
  static const int disAydinlatma = 0x901;
  static const int pompa1 = 0x902;
  static const int pompa2 = 0x903;
  static const int sintinePompa = 0x904; // tri-state: kapali/acik/otomatik
  static const int klima = 0x905;
  static const int irgat = 0x906;
  static const int horn = 0x907;

  // Incoming — mock telemetry.
  static const int systemStatus = 0x910;
  static const int engineIskele = 0x911;
  static const int engineSancak = 0x912;
  static const int jenset1 = 0x913;
  static const int jenset2 = 0x914;
  static const int elektrikServis = 0x915;
  static const int elektrikInvertor = 0x916;
  static const int elektrikAku = 0x917;
  static const int tankYakit = 0x918;
  static const int tankTatliSu = 0x919;
  static const int tankPisSu = 0x91A;
  static const int tankSintine = 0x91B;
}
