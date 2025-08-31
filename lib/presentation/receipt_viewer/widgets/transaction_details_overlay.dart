import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Bottom overlay showing transaction details over the receipt image
class TransactionDetailsOverlay extends StatelessWidget {
  final Map<String, dynamic> transactionData;
  final VoidCallback? onEdit;
  final bool isVisible;

  const TransactionDetailsOverlay({
    super.key,
    required this.transactionData,
    this.onEdit,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction amount and type
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getTransactionTypeColor(
                          transactionData['type'] as String? ?? 'expense',
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getTransactionTypeColor(
                            transactionData['type'] as String? ?? 'expense',
                          ),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _formatTransactionType(
                          transactionData['type'] as String? ?? 'expense',
                        ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getTransactionTypeColor(
                            transactionData['type'] as String? ?? 'expense',
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatAmount(
                          transactionData['amount'] as double? ?? 0.0),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Transaction details
                _buildDetailRow(
                  context,
                  'Date',
                  _formatDate(transactionData['date'] as String? ?? ''),
                ),

                SizedBox(height: 1.h),

                _buildDetailRow(
                  context,
                  'Category',
                  transactionData['category'] as String? ?? 'General',
                ),

                if ((transactionData['description'] as String?)?.isNotEmpty ==
                    true) ...[
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    'Description',
                    transactionData['description'] as String? ?? '',
                  ),
                ],

                SizedBox(height: 2.h),

                // Edit button
                if (onEdit != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'Edit Transaction',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.w,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Color _getTransactionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'income':
        return AppTheme.getSuccessColor(true);
      case 'expense':
        return AppTheme.getErrorColor(true);
      default:
        return AppTheme.getWarningColor(true);
    }
  }

  String _formatTransactionType(String type) {
    return type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase();
  }

  String _formatAmount(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
