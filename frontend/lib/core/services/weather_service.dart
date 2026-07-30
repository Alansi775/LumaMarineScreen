import 'dart:convert';

import 'package:flutter/material.dart' show IconData, Icons;
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_service.g.dart';

/// Confirmed with the client: no GPS yet, so weather uses a fixed
/// location (Istanbul) until a real GPS module reports the yacht's
/// actual position. The device has Ethernet, so this is real live data,
/// not a placeholder — unlike GPS/Speed/Heading/Outside Temp.
const double _istanbulLat = 41.0082;
const double _istanbulLon = 28.9784;

class WeatherReading {
  const WeatherReading({required this.temperatureC, required this.condition, required this.icon});

  final double temperatureC;
  final String condition;
  final IconData icon;
}

/// Maps Open-Meteo's WMO weather codes to a short Turkish condition
/// label + a representative icon. Not exhaustive — collapses the full
/// WMO table into the handful of conditions worth distinguishing on a
/// small status card.
WeatherReading _fromWmoCode(int code, double tempC) {
  final (condition, icon) = switch (code) {
    0 => ('AÇIK', Icons.wb_sunny_outlined),
    1 || 2 => ('PARÇALI BULUTLU', Icons.wb_cloudy_outlined),
    3 => ('KAPALI', Icons.cloud_outlined),
    45 || 48 => ('SİSLİ', Icons.foggy),
    51 || 53 || 55 || 56 || 57 => ('ÇİSENTİLİ', Icons.grain),
    61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => ('YAĞMURLU', Icons.water_drop_outlined),
    71 || 73 || 75 || 77 || 85 || 86 => ('KARLI', Icons.ac_unit),
    95 || 96 || 99 => ('FIRTINALI', Icons.thunderstorm_outlined),
    _ => ('—', Icons.cloud_outlined),
  };
  return WeatherReading(temperatureC: tempC, condition: condition, icon: icon);
}

/// Fetches live weather every 10 minutes via Open-Meteo (no API key
/// required) for the fixed Istanbul location. Errors surface as a null
/// value so the UI can show its own "no data" treatment rather than
/// crash the dashboard over a flaky network call.
@riverpod
Stream<WeatherReading?> weather(WeatherRef ref) async* {
  final client = http.Client();
  ref.onDispose(client.close);

  Future<WeatherReading?> fetch() async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$_istanbulLat&longitude=$_istanbulLon'
        '&current=temperature_2m,weather_code&timezone=auto',
      );
      final response = await client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final current = body['current'] as Map<String, dynamic>;
      final temp = (current['temperature_2m'] as num).toDouble();
      final code = (current['weather_code'] as num).toInt();
      return _fromWmoCode(code, temp);
    } catch (_) {
      return null;
    }
  }

  yield await fetch();
  yield* Stream.periodic(const Duration(minutes: 10)).asyncMap((_) => fetch());
}
