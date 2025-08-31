import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final String? selectedType;
  final Function(List<String>, double?, double?, String?) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategories,
    this.minAmount,
    this.maxAmount,
    this.selectedType,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedCategories;
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  String? _selectedType;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Salary',
    'Business',
    'Investment',
  ];

  final List<String> _transactionTypes = ['All', 'Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _minAmountController = TextEditingController(
      text: widget.minAmount?.toString() ?? '',
    );
    _maxAmountController = TextEditingController(
      text: widget.maxAmount?.toString() ?? '',
    );
    _selectedType = widget.selectedType ?? 'All';
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Transactions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type
                  _buildSectionTitle('Transaction Type'),
                  SizedBox(height: 1.h),
                  _buildTransactionTypeSelector(),

                  SizedBox(height: 3.h),

                  // Amount Range
                  _buildSectionTitle('Amount Range'),
                  SizedBox(height: 1.h),
                  _buildAmountRangeInputs(),

                  SizedBox(height: 3.h),

                  // Categories
                  _buildSectionTitle('Categories'),
                  SizedBox(height: 1.h),
                  _buildCategorySelector(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 2.w,
      children: _transactionTypes.map((type) {
        final isSelected = _selectedType == type;
        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedType = selected ? type : 'All';
            });
          },
          backgroundColor: colorScheme.surface,
          selectedColor: colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: colorScheme.primary,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountRangeInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Min Amount',
              prefixText: '\$',
              hintText: '0.00',
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'to',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: TextField(
            controller: _maxAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Max Amount',
              prefixText: '\$',
              hintText: '999.99',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _categories.map((category) {
        final isSelected = _selectedCategories.contains(category);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: _getCategoryIcon(category),
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(category),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories.remove(category);
              }
            });
          },
          backgroundColor: colorScheme.surface,
          selectedColor: colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: colorScheme.primary,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
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

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
      _selectedType = 'All';
    });
  }

  void _applyFilters() {
    final minAmount = _minAmountController.text.isNotEmpty
        ? double.tryParse(_minAmountController.text)
        : null;
    final maxAmount = _maxAmountController.text.isNotEmpty
        ? double.tryParse(_maxAmountController.text)
        : null;

    widget.onApplyFilters(
      _selectedCategories,
      minAmount,
      maxAmount,
      _selectedType == 'All' ? null : _selectedType,
    );

    Navigator.pop(context);
  }
}
