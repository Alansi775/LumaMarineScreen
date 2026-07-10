import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/toilet_channel.dart';

/// Power toggle + PWM slider for one pump channel — the same "toggle
/// then adjust" interaction as Lighting, applied to pump duty cycle
/// instead of brightness.
class ToiletChannelRow extends StatelessWidget {
  const ToiletChannelRow({
    super.key,
    required this.channel,
    required this.onToggle,
    required this.onPwmChanged,
  });

  final ToiletChannel channel;
  final VoidCallback onToggle;
  final ValueChanged<int> onPwmChanged;

  @override
  Widget build(BuildContext context) {
    final isOn = channel.isOn;
    final color = AppColors.water;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? color.withValues(alpha: 0.16) : AppColors.gaugeTrack,
                border: Border.all(color: isOn ? color.withValues(alpha: 0.5) : AppColors.hairline),
              ),
              child: Icon(
                Icons.power_settings_new_rounded,
                size: 18,
                color: isOn ? color : AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: Text(channel.name, style: AppTextStyles.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                inactiveTrackColor: AppColors.gaugeTrack,
                thumbColor: color,
                overlayColor: color.withValues(alpha: 0.15),
                trackHeight: 6,
              ),
              child: Slider(
                value: channel.pwmValue.toDouble(),
                min: 0,
                max: 1000,
                onChanged: isOn ? (v) => onPwmChanged(v.round()) : null,
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '${(channel.pwmValue / 10).round()}%',
              textAlign: TextAlign.right,
              style: AppTextStyles.numeralMedium.copyWith(color: isOn ? color : AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
