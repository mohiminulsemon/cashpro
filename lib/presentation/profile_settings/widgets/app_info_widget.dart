import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// App information and support links widget
class AppInfoWidget extends StatelessWidget {
  final String appVersion;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsOfServiceTap;
  final VoidCallback? onSupportTap;
  final VoidCallback? onRateAppTap;

  const AppInfoWidget({
    super.key,
    required this.appVersion,
    this.onPrivacyPolicyTap,
    this.onTermsOfServiceTap,
    this.onSupportTap,
    this.onRateAppTap,
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
        children: [
          // App Logo and Version
          Column(
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: Colors.white,
                    size: 8.w,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'CashBook',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Version $appVersion',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Support Links
          Column(
            children: [
              _buildInfoItem(
                context,
                title: 'Privacy Policy',
                iconName: 'privacy_tip',
                onTap: onPrivacyPolicyTap,
              ),
              _buildInfoItem(
                context,
                title: 'Terms of Service',
                iconName: 'description',
                onTap: onTermsOfServiceTap,
              ),
              _buildInfoItem(
                context,
                title: 'Support & Help',
                iconName: 'help_outline',
                onTap: onSupportTap,
              ),
              _buildInfoItem(
                context,
                title: 'Rate This App',
                iconName: 'star_outline',
                onTap: onRateAppTap,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String title,
    required String iconName,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(2.w),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2.w,
              vertical: 2.h,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'open_in_new',
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 4.w,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
            indent: 9.w,
          ),
      ],
    );
  }
}
