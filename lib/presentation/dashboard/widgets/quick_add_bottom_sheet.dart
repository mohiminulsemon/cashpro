import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAddBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onTransactionAdded;

  const QuickAddBottomSheet({
    super.key,
    required this.onTransactionAdded,
  });

  @override
  State<QuickAddBottomSheet> createState() => _QuickAddBottomSheetState();
}

class _QuickAddBottomSheetState extends State<QuickAddBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedType = 'expense';
  String _selectedCategory = 'Other';

  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Other'
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Freelance',
    'Other'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 6.w,
        right: 6.w,
        top: 4.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 4.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Quick Add Transaction',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 4.h),

          // Transaction Type Toggle
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = 'expense';
                      _selectedCategory = _expenseCategories.first;
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _selectedType == 'expense'
                            ? colorScheme.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedType == 'expense'
                            ? [
                                BoxShadow(
                                  color:
                                      colorScheme.shadow.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'trending_down',
                            color: _selectedType == 'expense'
                                ? AppTheme.getErrorColor(
                                    theme.brightness == Brightness.light)
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Expense',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedType == 'expense'
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _selectedType == 'expense'
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = 'income';
                      _selectedCategory = _incomeCategories.first;
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _selectedType == 'income'
                            ? colorScheme.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedType == 'income'
                            ? [
                                BoxShadow(
                                  color:
                                      colorScheme.shadow.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'trending_up',
                            color: _selectedType == 'income'
                                ? AppTheme.getSuccessColor(
                                    theme.brightness == Brightness.light)
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Income',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedType == 'income'
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _selectedType == 'income'
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Amount Input
          Text(
            'Amount',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: '0.00',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'attach_money',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 3.h),

          // Category Selection
          Text(
            'Category',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                items: (_selectedType == 'expense'
                        ? _expenseCategories
                        : _incomeCategories)
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Description Input
          Text(
            'Description (Optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description...',
            ),
            maxLines: 2,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
          ),

          SizedBox(height: 4.h),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addTransaction,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Transaction',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTransaction() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final transaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': _selectedType,
      'amount': amount,
      'category': _selectedCategory,
      'description': _descriptionController.text.isEmpty
          ? _selectedCategory
          : _descriptionController.text,
      'date': DateTime.now(),
    };

    widget.onTransactionAdded(transaction);
    Navigator.of(context).pop();
  }
}
