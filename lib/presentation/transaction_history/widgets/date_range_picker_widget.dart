import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum DateRangePreset { today, week, month, year, custom }

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final DateRangePreset selectedPreset;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final ValueChanged<DateRangePreset> onPresetChanged;

  const DateRangePickerWidget({
    super.key,
    this.selectedRange,
    required this.selectedPreset,
    required this.onRangeChanged,
    required this.onPresetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'date_range',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Date Range',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showDateRangePicker(context),
                child: Text(
                  'Custom',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: DateRangePreset.values.map((preset) {
                if (preset == DateRangePreset.custom)
                  return const SizedBox.shrink();

                final isSelected = selectedPreset == preset;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(_getPresetLabel(preset)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onPresetChanged(preset);
                        onRangeChanged(_getDateRangeForPreset(preset));
                      }
                    },
                    backgroundColor: colorScheme.surface,
                    selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: colorScheme.primary,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedRange != null) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _formatDateRange(selectedRange!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPresetLabel(DateRangePreset preset) {
    switch (preset) {
      case DateRangePreset.today:
        return 'Today';
      case DateRangePreset.week:
        return 'This Week';
      case DateRangePreset.month:
        return 'This Month';
      case DateRangePreset.year:
        return 'This Year';
      case DateRangePreset.custom:
        return 'Custom';
    }
  }

  DateTimeRange _getDateRangeForPreset(DateRangePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (preset) {
      case DateRangePreset.today:
        return DateTimeRange(
          start: today,
          end: today
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1)),
        );
      case DateRangePreset.week:
        final weekStart = today.subtract(Duration(days: now.weekday - 1));
        return DateTimeRange(
          start: weekStart,
          end: weekStart
              .add(const Duration(days: 7))
              .subtract(const Duration(seconds: 1)),
        );
      case DateRangePreset.month:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(seconds: 1));
        return DateTimeRange(start: monthStart, end: monthEnd);
      case DateRangePreset.year:
        final yearStart = DateTime(now.year, 1, 1);
        final yearEnd =
            DateTime(now.year + 1, 1, 1).subtract(const Duration(seconds: 1));
        return DateTimeRange(start: yearStart, end: yearEnd);
      case DateRangePreset.custom:
        return DateTimeRange(start: today, end: today);
    }
  }

  String _formatDateRange(DateTimeRange range) {
    final startDate =
        '${range.start.day}/${range.start.month}/${range.start.year}';
    final endDate = '${range.end.day}/${range.end.month}/${range.end.year}';

    if (range.start.day == range.end.day &&
        range.start.month == range.end.month &&
        range.start.year == range.end.year) {
      return startDate;
    }

    return '$startDate - $endDate';
  }

  void _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onPresetChanged(DateRangePreset.custom);
      onRangeChanged(picked);
    }
  }
}
