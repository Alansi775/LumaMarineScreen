import 'package:flutter/widgets.dart';

/// A momentary-release door/hatch actuator. Pressing opens it; it re-closes
/// itself automatically after a short pulse (see [DoorsController.trigger]) —
/// this models a real solenoid release, not a persistent toggle.
class Door {
  const Door({
    required this.id,
    required this.name,
    required this.icon,
    this.isOpen = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final bool isOpen;

  Door copyWith({bool? isOpen}) {
    return Door(id: id, name: name, icon: icon, isOpen: isOpen ?? this.isOpen);
  }
}
