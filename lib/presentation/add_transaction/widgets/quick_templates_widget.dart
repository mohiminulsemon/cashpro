import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickTemplate {
  final String id;
  final String name;
  final String amount;
  final String description;
  final String categoryId;
  final String iconName;
  final Color color;
  final bool isIncome;

  const QuickTemplate({
    required this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.iconName,
    required this.color,
    required this.isIncome,
  });
}

class QuickTemplatesWidget extends StatelessWidget {
  final Function(QuickTemplate) onTemplateSelected;
  final bool isIncomeType;

  const QuickTemplatesWidget({
    super.key,
    required this.onTemplateSelected,
    required this.isIncomeType,
  });

  // Mock quick templates
  final List<QuickTemplate> _incomeTemplates = const [
    QuickTemplate(
      id: '1',
      name: 'Salary',
      amount: '3000.00',
      description: 'Monthly salary payment',
      categoryId: '1',
      iconName: 'work',
      color: Colors.green,
      isIncome: true,
    ),
    QuickTemplate(
      id: '2',
      name: 'Freelance',
      amount: '500.00',
      description: 'Freelance project payment',
      categoryId: '4',
      iconName: 'laptop',
      color: Colors.orange,
      isIncome: true,
    ),
    QuickTemplate(
      id: '3',
      name: 'Investment',
      amount: '200.00',
      description: 'Investment return',
      categoryId: '3',
      iconName: 'trending_up',
      color: Colors.purple,
      isIncome: true,
    ),
    QuickTemplate(
      id: '4',
      name: 'Bonus',
      amount: '1000.00',
      description: 'Performance bonus',
      categoryId: '7',
      iconName: 'star',
      color: Colors.amber,
      isIncome: true,
    ),
  ];

  final List<QuickTemplate> _expenseTemplates = const [
    QuickTemplate(
      id: '5',
      name: 'Coffee',
      amount: '5.50',
      description: 'Coffee shop',
      categoryId: '18',
      iconName: 'local_cafe',
      color: Colors.brown,
      isIncome: false,
    ),
    QuickTemplate(
      id: '6',
      name: 'Fuel',
      amount: '45.00',
      description: 'Fuel for car',
      categoryId: '17',
      iconName: 'local_gas_station',
      color: Colors.brown,
      isIncome: false,
    ),
    QuickTemplate(
      id: '7',
      name: 'Lunch',
      amount: '12.00',
      description: 'Lunch at restaurant',
      categoryId: '9',
      iconName: 'restaurant',
      color: Colors.red,
      isIncome: false,
    ),
    QuickTemplate(
      id: '8',
      name: 'Groceries',
      amount: '85.00',
      description: 'Weekly groceries',
      categoryId: '19',
      iconName: 'local_grocery_store',
      color: Colors.green,
      isIncome: false,
    ),
  ];

  List<QuickTemplate> get _currentTemplates =>
      isIncomeType ? _incomeTemplates : _expenseTemplates;

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
            children: [
              CustomIconWidget(
                iconName: 'flash_on',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Templates',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _currentTemplates.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final template = _currentTemplates[index];
                return _buildTemplateCard(template, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(QuickTemplate template, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        onTemplateSelected(template);
        HapticFeedback.lightImpact();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 25.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: template.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: template.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: template.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: template.iconName,
                color: template.color,
                size: 20,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              template.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: template.color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              '\$${template.amount}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
