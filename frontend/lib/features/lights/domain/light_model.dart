import 'package:flutter/material.dart';

/// A single user-managed light. Fully user-defined — there is no hardcoded
/// list; lights are added via [LightsController.addLight].
class Light {
  const Light({
    required this.id,
    required this.name,
    required this.icon,
    required this.isOn,
    this.brightness = 1000,
  });

  final String id;
  final String name;
  final IconData icon;
  final bool isOn;

  /// 0-1000, matches the ESP32 slider range (LED_CMD_SET_BRIGHTNESS).
  final int brightness;

  Light copyWith({bool? isOn, int? brightness}) {
    return Light(
      id: id,
      name: name,
      icon: icon,
      isOn: isOn ?? this.isOn,
      brightness: brightness ?? this.brightness,
    );
  }
}

/// Icon choices offered in the "add light" flow.
const lightIconChoices = <IconData>[
  Icons.lightbulb_outline,
  Icons.wb_incandescent_outlined,
  Icons.deck_outlined,
  Icons.bed_outlined,
  Icons.kitchen_outlined,
  Icons.night_shelter_outlined,
  Icons.deck,
  Icons.balcony_outlined,
];
