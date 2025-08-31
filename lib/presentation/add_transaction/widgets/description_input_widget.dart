import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DescriptionInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onDescriptionChanged;
  final bool isIncomeType;

  const DescriptionInputWidget({
    super.key,
    required this.controller,
    required this.onDescriptionChanged,
    required this.isIncomeType,
  });

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Mock transaction history suggestions
  final List<String> _incomeSuggestions = [
    'Salary payment',
    'Freelance project',
    'Business revenue',
    'Investment return',
    'Rental income',
    'Bonus payment',
    'Gift received',
    'Commission earned',
  ];

  final List<String> _expenseSuggestions = [
    'Lunch at restaurant',
    'Coffee shop',
    'Grocery shopping',
    'Fuel for car',
    'Electricity bill',
    'Internet bill',
    'Movie tickets',
    'Uber ride',
    'Medical checkup',
    'Book purchase',
    'Gym membership',
    'Phone recharge',
  ];

  List<String> get _currentSuggestions =>
      widget.isIncomeType ? _incomeSuggestions : _expenseSuggestions;

  List<String> get _filteredSuggestions {
    if (widget.controller.text.isEmpty) {
      return _currentSuggestions.take(4).toList();
    }
    return _currentSuggestions
        .where((suggestion) => suggestion
            .toLowerCase()
            .contains(widget.controller.text.toLowerCase()))
        .take(4)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 3,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: widget.isIncomeType
                  ? 'e.g., Salary payment, Freelance work...'
                  : 'e.g., Lunch, Coffee, Groceries...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              widget.onDescriptionChanged(value);
              setState(() {});
            },
          ),
          if (_showSuggestions && _filteredSuggestions.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              'Suggestions',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _filteredSuggestions.map((suggestion) {
                return _buildSuggestionChip(suggestion, context);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        widget.controller.text = suggestion;
        widget.onDescriptionChanged(suggestion);
        _focusNode.unfocus();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: colorScheme.primary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              suggestion,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
