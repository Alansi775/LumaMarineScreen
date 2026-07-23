import 'package:flutter/material.dart';

import 'widgets/time_date_display.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: TimeDateDisplay()),
    );
  }
}
