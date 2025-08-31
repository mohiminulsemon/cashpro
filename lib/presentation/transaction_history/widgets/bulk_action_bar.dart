import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;
  final VoidCallback? onBulkDelete;
  final VoidCallback? onBulkExport;
  final VoidCallback? onBulkShare;
  final VoidCallback? onCancel;

  const BulkActionBar({
    super.key,
    required this.selectedCount,
    this.onSelectAll,
    this.onDeselectAll,
    this.onBulkDelete,
    this.onBulkExport,
    this.onBulkShare,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              // Cancel button
              IconButton(
                onPressed: onCancel,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: colorScheme.onSurface,
                  size: 24,
                ),
                tooltip: 'Cancel selection',
              ),

              SizedBox(width: 2.w),

              // Selected count
              Expanded(
                child: Text(
                  '$selectedCount selected',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Select/Deselect all
              TextButton(
                onPressed: selectedCount > 0 ? onDeselectAll : onSelectAll,
                child: Text(
                  selectedCount > 0 ? 'Deselect All' : 'Select All',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Action buttons
              if (selectedCount > 0) ...[
                // Export button
                IconButton(
                  onPressed: onBulkExport,
                  icon: CustomIconWidget(
                    iconName: 'file_download',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  tooltip: 'Export selected',
                ),

                // Share button
                IconButton(
                  onPressed: onBulkShare,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  tooltip: 'Share selected',
                ),

                // Delete button
                IconButton(
                  onPressed: () => _showBulkDeleteConfirmation(context),
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.getErrorColor(
                        theme.brightness == Brightness.light),
                    size: 24,
                  ),
                  tooltip: 'Delete selected',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showBulkDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Transactions',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete $selectedCount transaction${selectedCount != 1 ? 's' : ''}? This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onBulkDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppTheme.getErrorColor(theme.brightness == Brightness.light),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
