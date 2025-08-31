import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Profile header widget displaying user information and account type
class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;
  final String accountType;
  final VoidCallback? onProfileTap;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.profileImageUrl,
    required this.accountType,
    this.onProfileTap,
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
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: profileImageUrl.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: profileImageUrl,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: colorScheme.primary,
                            size: 8.w,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 4.w),

              // User Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : 'User Name',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userEmail.isNotEmpty ? userEmail : 'user@example.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),

                    // Account Type Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        accountType.isNotEmpty ? accountType : 'Personal',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Edit Icon
              CustomIconWidget(
                iconName: 'edit',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
