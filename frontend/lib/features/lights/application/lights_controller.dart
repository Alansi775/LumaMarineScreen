import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/light_model.dart';

part 'lights_controller.g.dart';

/// In-memory light registry. Fully user-managed: toggle on/off, add new
/// named lights. Persistence across app restarts plugs in here later by
/// swapping [build]'s seed + adding a save-on-mutation call — no UI change.
@riverpod
class LightsController extends _$LightsController {
  @override
  List<Light> build() {
    return const [
      Light(id: 'salon', name: 'Salon Lamp', icon: Icons.lightbulb_outline, isOn: true),
      Light(id: 'cockpit', name: 'Cockpit LED', icon: Icons.wb_incandescent_outlined, isOn: false),
      Light(id: 'cabin', name: 'Cabin', icon: Icons.bed_outlined, isOn: false),
      Light(id: 'galley', name: 'Galley', icon: Icons.kitchen_outlined, isOn: true),
      Light(id: 'deck', name: 'Deck', icon: Icons.deck_outlined, isOn: false),
      Light(id: 'anchor', name: 'Anchor Light', icon: Icons.night_shelter_outlined, isOn: false),
    ];
  }

  void toggle(String id) {
    state = [
      for (final light in state)
        if (light.id == id) light.copyWith(isOn: !light.isOn) else light,
    ];
  }

  void addLight({required String name, required IconData icon}) {
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    state = [...state, Light(id: id, name: name, icon: icon, isOn: false)];
  }
}
