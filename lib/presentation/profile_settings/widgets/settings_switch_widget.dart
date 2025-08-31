import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Settings switch widget for toggle-based settings
class SettingsSwitchWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;

  const SettingsSwitchWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.value,
    this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 3.h,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: iconColor ?? colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            inactiveThumbColor: colorScheme.onSurface.withValues(alpha: 0.4),
            inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
