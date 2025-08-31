import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategoryData {
  final String id;
  final String name;
  final String iconName;
  final Color color;
  final bool isIncome;

  const CategoryData({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
    required this.isIncome,
  });
}

class CategoryPickerWidget extends StatefulWidget {
  final CategoryData? selectedCategory;
  final Function(CategoryData) onCategorySelected;
  final bool isIncomeType;

  const CategoryPickerWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    required this.isIncomeType,
  });

  @override
  State<CategoryPickerWidget> createState() => _CategoryPickerWidgetState();
}

class _CategoryPickerWidgetState extends State<CategoryPickerWidget> {
  bool _showAllCategories = false;

  // Mock categories data
  final List<CategoryData> _incomeCategories = [
    CategoryData(
        id: '1',
        name: 'Salary',
        iconName: 'work',
        color: Colors.green,
        isIncome: true),
    CategoryData(
        id: '2',
        name: 'Business',
        iconName: 'business',
        color: Colors.blue,
        isIncome: true),
    CategoryData(
        id: '3',
        name: 'Investment',
        iconName: 'trending_up',
        color: Colors.purple,
        isIncome: true),
    CategoryData(
        id: '4',
        name: 'Freelance',
        iconName: 'laptop',
        color: Colors.orange,
        isIncome: true),
    CategoryData(
        id: '5',
        name: 'Rental',
        iconName: 'home',
        color: Colors.teal,
        isIncome: true),
    CategoryData(
        id: '6',
        name: 'Gift',
        iconName: 'card_giftcard',
        color: Colors.pink,
        isIncome: true),
    CategoryData(
        id: '7',
        name: 'Bonus',
        iconName: 'star',
        color: Colors.amber,
        isIncome: true),
    CategoryData(
        id: '8',
        name: 'Other',
        iconName: 'more_horiz',
        color: Colors.grey,
        isIncome: true),
  ];

  final List<CategoryData> _expenseCategories = [
    CategoryData(
        id: '9',
        name: 'Food',
        iconName: 'restaurant',
        color: Colors.red,
        isIncome: false),
    CategoryData(
        id: '10',
        name: 'Transport',
        iconName: 'directions_car',
        color: Colors.blue,
        isIncome: false),
    CategoryData(
        id: '11',
        name: 'Shopping',
        iconName: 'shopping_bag',
        color: Colors.purple,
        isIncome: false),
    CategoryData(
        id: '12',
        name: 'Bills',
        iconName: 'receipt',
        color: Colors.orange,
        isIncome: false),
    CategoryData(
        id: '13',
        name: 'Health',
        iconName: 'local_hospital',
        color: Colors.green,
        isIncome: false),
    CategoryData(
        id: '14',
        name: 'Entertainment',
        iconName: 'movie',
        color: Colors.pink,
        isIncome: false),
    CategoryData(
        id: '15',
        name: 'Education',
        iconName: 'school',
        color: Colors.indigo,
        isIncome: false),
    CategoryData(
        id: '16',
        name: 'Travel',
        iconName: 'flight',
        color: Colors.cyan,
        isIncome: false),
    CategoryData(
        id: '17',
        name: 'Fuel',
        iconName: 'local_gas_station',
        color: Colors.brown,
        isIncome: false),
    CategoryData(
        id: '18',
        name: 'Coffee',
        iconName: 'local_cafe',
        color: Colors.brown.shade300,
        isIncome: false),
    CategoryData(
        id: '19',
        name: 'Groceries',
        iconName: 'local_grocery_store',
        color: Colors.green.shade600,
        isIncome: false),
    CategoryData(
        id: '20',
        name: 'Other',
        iconName: 'more_horiz',
        color: Colors.grey,
        isIncome: false),
  ];

  List<CategoryData> get _currentCategories =>
      widget.isIncomeType ? _incomeCategories : _expenseCategories;

  List<CategoryData> get _displayedCategories => _showAllCategories
      ? _currentCategories
      : _currentCategories.take(6).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.selectedCategory != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        widget.selectedCategory!.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          widget.selectedCategory!.color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: widget.selectedCategory!.iconName,
                        color: widget.selectedCategory!.color,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        widget.selectedCategory!.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: widget.selectedCategory!.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _displayedCategories.map((category) {
              final isSelected = widget.selectedCategory?.id == category.id;
              return _buildCategoryChip(category, isSelected, context);
            }).toList(),
          ),
          if (_currentCategories.length > 6) ...[
            SizedBox(height: 2.h),
            InkWell(
              onTap: () {
                setState(() {
                  _showAllCategories = !_showAllCategories;
                });
                HapticFeedback.lightImpact();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllCategories ? 'Show Less' : 'Show More Categories',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName:
                          _showAllCategories ? 'expand_less' : 'expand_more',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      CategoryData category, bool isSelected, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        widget.onCategorySelected(category);
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.15)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? category.color
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: category.iconName,
              color: isSelected
                  ? category.color
                  : colorScheme.onSurface.withValues(alpha: 0.7),
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              category.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? category.color
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
