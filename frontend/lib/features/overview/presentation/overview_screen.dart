import 'package:flutter/material.dart';

import 'widgets/time_date_display.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF07080A),
      child: const SafeArea(
        child: Center(child: TimeDateDisplay()),
      ),
    );
  }
}
