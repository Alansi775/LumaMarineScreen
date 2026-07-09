import 'package:flutter/material.dart';

/// A single user-managed light. Fully user-defined — there is no hardcoded
/// list; lights are added via [LightsController.addLight].
class Light {
  const Light({
    required this.id,
    required this.name,
    required this.icon,
    required this.isOn,
  });

  final String id;
  final String name;
  final IconData icon;
  final bool isOn;

  Light copyWith({bool? isOn}) {
    return Light(
      id: id,
      name: name,
      icon: icon,
      isOn: isOn ?? this.isOn,
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
