import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const RecentTransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String type = (transaction['type'] as String?) ?? 'expense';
    final String description =
        (transaction['description'] as String?) ?? 'No description';
    final double amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final String category = (transaction['category'] as String?) ?? 'Other';
    final DateTime date = transaction['date'] as DateTime? ?? DateTime.now();

    final bool isIncome = type.toLowerCase() == 'income';
    final Color amountColor = isIncome
        ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
        : AppTheme.getErrorColor(theme.brightness == Brightness.light);

    return Dismissible(
      key: Key(
          'transaction_${transaction['id'] ?? DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'edit',
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        onEdit?.call();
        return false; // Don't actually dismiss, just trigger edit
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4.w),
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomIconWidget(
                  iconName: _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _formatDate(date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: amountColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
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
      case 'salary':
        return const Color(0xFF81C784);
      case 'business':
        return const Color(0xFF64B5F6);
      case 'investment':
        return const Color(0xFFBA68C8);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
