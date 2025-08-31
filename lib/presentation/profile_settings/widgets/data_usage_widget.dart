import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Data usage and storage information widget
class DataUsageWidget extends StatelessWidget {
  final String storageUsed;
  final String totalStorage;
  final double usagePercentage;
  final String lastBackupTime;
  final VoidCallback? onBackupTap;
  final VoidCallback? onExportTap;

  const DataUsageWidget({
    super.key,
    required this.storageUsed,
    required this.totalStorage,
    required this.usagePercentage,
    required this.lastBackupTime,
    this.onBackupTap,
    this.onExportTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Storage Usage Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'storage',
                color: colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Storage Usage',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Usage Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    storageUsed,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    totalStorage,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Progress Bar
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: usagePercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: usagePercentage > 80
                          ? colorScheme.error
                          : usagePercentage > 60
                              ? AppTheme.getWarningColor(
                                  theme.brightness == Brightness.light)
                              : colorScheme.primary,
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Last Backup Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'cloud_done',
                      color: AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last Backup',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  lastBackupTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBackupTap,
                  icon: CustomIconWidget(
                    iconName: 'backup',
                    color: colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text(
                    'Backup Now',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onExportTap,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  label: Text(
                    'Export Data',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
