import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Small-caps letter-spaced header used above every card/section, e.g.
/// "BATTERIES". A short accent tick precedes the text for a console feel.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.sectionLabel),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}
