import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final String searchQuery;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onReceiptView;

  const TransactionCardWidget({
    super.key,
    required this.transaction,
    this.searchQuery = '',
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.onShare,
    this.onReceiptView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = (transaction['type'] as String).toLowerCase() == 'income';
    final amount = transaction['amount'] as double;
    final hasReceipt = transaction['hasReceipt'] as bool? ?? false;

    return Dismissible(
      key: Key('transaction_${transaction['id']}'),
      background: _buildSwipeBackground(context, isLeftSwipe: false),
      secondaryBackground: _buildSwipeBackground(context, isLeftSwipe: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        } else if (direction == DismissDirection.endToStart) {
          _showDeleteConfirmation(context);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false; // Don't dismiss for edit action
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(transaction['category'] as String)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName:
                          _getCategoryIcon(transaction['category'] as String),
                      color:
                          _getCategoryColor(transaction['category'] as String),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildHighlightedText(
                              transaction['description'] as String,
                              searchQuery,
                              theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              colorScheme.primary,
                            ),
                          ),
                          if (hasReceipt)
                            GestureDetector(
                              onTap: onReceiptView,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'camera_alt',
                                  color: colorScheme.primary,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          _buildHighlightedText(
                            transaction['category'] as String,
                            searchQuery,
                            theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            colorScheme.primary,
                          ),
                          Text(
                            ' • ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          Text(
                            _formatDate(
                                DateTime.parse(transaction['date'] as String)),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isIncome
                            ? AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light)
                            : AppTheme.getErrorColor(
                                theme.brightness == Brightness.light),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _formatTime(
                          DateTime.parse(transaction['date'] as String)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context,
      {required bool isLeftSwipe}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isLeftSwipe
            ? AppTheme.getErrorColor(theme.brightness == Brightness.light)
            : colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeftSwipe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeftSwipe ? 'delete' : 'edit',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeftSwipe ? 'Delete' : 'Edit',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle? style,
    Color highlightColor,
  ) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: style);
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          if (index > 0) TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: style?.copyWith(
              backgroundColor: highlightColor.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              context,
              'Edit Transaction',
              'edit',
              onEdit,
            ),
            _buildContextMenuItem(
              context,
              'Duplicate Transaction',
              'content_copy',
              onDuplicate,
            ),
            _buildContextMenuItem(
              context,
              'Share Transaction',
              'share',
              onShare,
            ),
            _buildContextMenuItem(
              context,
              'Delete Transaction',
              'delete',
              () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.getErrorColor(theme.brightness == Brightness.light)
            : colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.getErrorColor(theme.brightness == Brightness.light)
              : colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Transaction',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              onDelete?.call();
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

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'restaurant';
      case 'transport':
        return 'directions_car';
      case 'shopping':
        return 'shopping_bag';
      case 'entertainment':
        return 'movie';
      case 'bills':
        return 'receipt_long';
      case 'health':
        return 'local_hospital';
      case 'education':
        return 'school';
      case 'salary':
        return 'work';
      case 'business':
        return 'business';
      case 'investment':
        return 'trending_up';
      default:
        return 'category';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF6B6B);
      case 'transport':
        return const Color(0xFF4ECDC4);
      case 'shopping':
        return const Color(0xFFFFE66D);
      case 'entertainment':
        return const Color(0xFFFF8B94);
      case 'bills':
        return const Color(0xFFA8E6CF);
      case 'health':
        return const Color(0xFFFFAB91);
      case 'education':
        return const Color(0xFF81C784);
      case 'salary':
        return const Color(0xFF64B5F6);
      case 'business':
        return const Color(0xFFBA68C8);
      case 'investment':
        return const Color(0xFF4DB6AC);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
