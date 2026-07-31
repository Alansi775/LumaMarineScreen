/// Centralized Turkish UI text for the SCADA dashboard redesign. Text
/// stays in Turkish verbatim per the client's reference design — this
/// file exists so every string lives in one place rather than scattered
/// inline in widgets, same maintainability principle as the rest of the
/// app; it just happens the values are Turkish right now.
///
/// NOTE: built from a text description of the client's reference
/// screenshot (MiRDEV "Tekne Otomasyon Sistemi"), not the image itself —
/// exact sub-labels not spelled out in that description (engine/
/// generator/electrical sub-fields) are best-effort marine-engineering
/// Turkish, flagged here for a quick client check once they see it
/// rendered.
class AppStrings {
  const AppStrings._();

  // ================= Top bar =================
  static const tagline = 'SMART YACHT CONTROL';
  static const versionPlaceholder = 'LUMA · GLC v1.0'; // TODO: confirm real version string
  static const mainTitle = 'TEKNE OTOMASYON SİSTEMİ';
  static const mainSubtitle = 'SCADA ANA EKRANI';

  // ================= Sidebar =================
  static const navAnaEkran = 'ANA EKRAN';
  static const navSeyirBilgileri = 'SEYİR BİLGİLERİ';
  static const navMakineDairesi = 'MAKİNE DAİRESİ';
  static const navAydinlatmaSistemi = 'AYDINLATMA SİSTEMİ';
  static const navElektrikSistemi = 'ELEKTRİK SİSTEMİ';
  static const navTankSeviyeleri = 'TANK SEVİYELERİ';
  static const navAlarmListesi = 'ALARM LİSTESİ';
  static const navTrendGrafikleri = 'TREND GRAFİKLERİ';
  static const navAyarlar = 'AYARLAR';
  static const navSistemBilgisi = 'SİSTEM BİLGİSİ';

  static const certCodePlaceholder = 'SERT. NO: TR-2026-0001'; // TODO: confirm real cert code
  static const ceMark = 'CE';

  // ================= Top row status cards =================
  static const cardSistemDurumu = 'SİSTEM DURUMU';
  static const sistemDurumuNormal = 'NORMAL';
  static const cardGpsKonumu = 'GPS KONUMU';
  static const cardHiz = 'HIZ';
  static const cardRota = 'ROTA';
  static const cardDisSicaklik = 'DIŞ SICAKLIK';
  static const cardHavaDurumu = 'HAVA DURUMU';

  // Placeholder text for hardware not installed yet — deliberately
  // distinct from live data ("— MODÜL YOK" style, confirmed with client).
  static const gpsModuluYok = 'GPS MODÜLÜ YOK';
  static const hizSensoruYok = 'HIZ SENSÖRÜ YOK';
  static const pusulaModuluYok = 'PUSULA MODÜLÜ YOK';
  static const sicaklikSensoruYok = 'SICAKLIK SENSÖRÜ YOK';
  static const placeholderDash = '—';

  // ================= Middle row =================
  static const aktifAlarmlar = 'AKTİF ALARMLAR';
  static const tumAlarmlariGor = 'TÜM ALARMLARI GÖR';

  // ================= Bottom row panels =================
  static const makineBilgileri = 'MAKİNE BİLGİLERİ';
  static const iskeleMotor = 'İSKELE MOTOR';
  static const sancakMotor = 'SANCAK MOTOR';
  static const rpmLabel = 'DEVİR';
  static const yagBasinciLabel = 'YAĞ BASINCI';
  static const yukLabel = 'YÜK';

  static const jeneratorler = 'JENERATÖRLER';
  static const jenset1 = 'JENSET 1';
  static const jenset2 = 'JENSET 2';

  static const elektrikSistemi = 'ELEKTRİK SİSTEMİ';
  static const servis = 'SERVİS';
  static const invertor = 'İNVERTÖR';
  static const akuBankasi = 'AKÜ BANKASI';
  static const dcNote = 'DC · gerçek AC ölçüm donanımı bağlanınca güncellenecek';

  static const tankSeviyeleri = 'TANK SEVİYELERİ';
  static const yakit = 'YAKIT';
  static const tatliSu = 'TATLI SU';
  static const pisSu = 'PİS SU';
  static const sintine = 'SİNTİNE';

  // ================= Bottom section =================
  static const sistemKontrolleri = 'SİSTEM KONTROLLERİ';
  static const icAydinlatma = 'İÇ AYDINLATMA';
  static const disAydinlatma = 'DIŞ AYDINLATMA';
  static const pompa1 = 'POMPA 1';
  static const pompa2 = 'POMPA 2';
  static const sintinePompa = 'SİNTİNE POMPA';
  static const klima = 'KLİMA';
  static const irgat = 'IRGAT';
  static const horn = 'HORN';

  static const acik = 'AÇIK';
  static const kapali = 'KAPALI';
  static const otomatik = 'OTOMATİK';

  static const hizliErisim = 'HIZLI ERİŞİM';
  static const manuelKontrol = 'MANUEL KONTROL';
  static const raporlar = 'RAPORLAR';
  static const kamera = 'KAMERA';
  static const bakim = 'BAKIM';

  // ================= Footer =================
  static const companyName = 'LUMA MARINE';
  static const sistemCalisiyor = 'SİSTEM ÇALIŞIYOR';

  // ================= Placeholder sections =================
  static const yakindaGeliyor = 'YAKINDA GELİYOR';
}
