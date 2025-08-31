import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Custom navigation bar for receipt viewer with close and action buttons
class ReceiptNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onClose;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onReCapture;
  final bool showActions;

  const ReceiptNavigationBar({
    super.key,
    required this.onClose,
    this.onShare,
    this.onDelete,
    this.onReCapture,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              // Close button
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const Spacer(),

              // Receipt title
              Text(
                'Receipt',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              // Action menu
              if (showActions)
                PopupMenuButton<String>(
                  onSelected: _handleMenuAction,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Share',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'recapture',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'camera_alt',
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Re-capture',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'delete_outline',
                            color: AppTheme.getErrorColor(
                              theme.brightness == Brightness.light,
                            ),
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Delete',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.getErrorColor(
                                theme.brightness == Brightness.light,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              else
                SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        onShare?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
      case 'recapture':
        onReCapture?.call();
        break;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 1.h);
}
