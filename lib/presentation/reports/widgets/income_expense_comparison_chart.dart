import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncomeExpenseComparisonChart extends StatefulWidget {
  final List<Map<String, dynamic>> comparisonData;

  const IncomeExpenseComparisonChart({
    super.key,
    required this.comparisonData,
  });

  @override
  State<IncomeExpenseComparisonChart> createState() =>
      _IncomeExpenseComparisonChartState();
}

class _IncomeExpenseComparisonChartState
    extends State<IncomeExpenseComparisonChart> {
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.comparisonData.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(
                iconName: 'bar_chart', color: colorScheme.primary, size: 20),
            SizedBox(width: 2.w),
            Text('Income vs Expenses',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 1.h),
          _buildLegend(context),
          SizedBox(height: 2.h),
          SizedBox(
              height: 25.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue() * 1.2,
                  barTouchData: BarTouchData(
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedGroupIndex = -1;
                            return;
                          }
                          touchedGroupIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipPadding: EdgeInsets.all(2.w),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final data = widget.comparisonData[groupIndex];
                            final isIncome = rodIndex == 0;
                            final amount = isIncome
                                ? data['income'] as double
                                : data['expense'] as double;

                            return BarTooltipItem(
                                '${data['period']}\n${isIncome ? 'Income' : 'Expense'}\n\$${amount.toStringAsFixed(2)}',
                                TextStyle(
                                    color: colorScheme.onInverseSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12));
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() <
                                        widget.comparisonData.length) {
                                  final data =
                                      widget.comparisonData[value.toInt()];
                                  return Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text(data['period'] as String,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: colorScheme.onSurface
                                                      .withValues(
                                                          alpha: 0.6))));
                                }
                                return const Text('');
                              },
                              reservedSize: 4.h)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 12.w,
                              interval: _getMaxValue() / 4,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                    '\$${(value / 1000).toStringAsFixed(0)}k',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.6)));
                              }))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border(
                          bottom: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                              width: 1),
                          left: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                              width: 1))),
                  barGroups: _buildBarGroups(),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getMaxValue() / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            strokeWidth: 1);
                      })))),
        ]));
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(children: [
      _buildLegendItem(context, 'Income',
          AppTheme.getSuccessColor(theme.brightness == Brightness.light)),
      SizedBox(width: 4.w),
      _buildLegendItem(context, 'Expenses',
          AppTheme.getErrorColor(theme.brightness == Brightness.light)),
    ]);
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      SizedBox(width: 1.w),
      Text(label,
          style:
              theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
    ]);
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.comparisonData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedGroupIndex;

      return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
                toY: data['income'] as double,
                color: AppTheme.getSuccessColor(
                    Theme.of(context).brightness == Brightness.light),
                width: isTouched ? 4.w : 3.w,
                borderRadius: BorderRadius.circular(2),
                backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: _getMaxValue(),
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1))),
            BarChartRodData(
                toY: data['expense'] as double,
                color: AppTheme.getErrorColor(
                    Theme.of(context).brightness == Brightness.light),
                width: isTouched ? 4.w : 3.w,
                borderRadius: BorderRadius.circular(2)),
          ],
          barsSpace: 1.w);
    }).toList();
  }

  double _getMaxValue() {
    double maxValue = 0;
    for (final data in widget.comparisonData) {
      final income = data['income'] as double;
      final expense = data['expense'] as double;
      if (income > maxValue) maxValue = income;
      if (expense > maxValue) maxValue = expense;
    }
    return maxValue;
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2), width: 1)),
        child: Column(children: [
          CustomIconWidget(
              iconName: 'bar_chart',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 48),
          SizedBox(height: 2.h),
          Text('No Comparison Data',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6))),
          SizedBox(height: 1.h),
          Text('Add transactions to compare income and expenses',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center),
        ]));
  }
}
