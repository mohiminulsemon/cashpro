import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySpendingTrends extends StatefulWidget {
  final List<Map<String, dynamic>> trendData;

  const CategorySpendingTrends({
    super.key,
    required this.trendData,
  });

  @override
  State<CategorySpendingTrends> createState() => _CategorySpendingTrendsState();
}

class _CategorySpendingTrendsState extends State<CategorySpendingTrends> {
  int touchedBarIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.trendData.isEmpty) {
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
                iconName: 'trending_up', color: colorScheme.primary, size: 20),
            SizedBox(width: 2.w),
            Text('Category Spending Trends',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 35.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue() * 1.1,
                  barTouchData: BarTouchData(
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedBarIndex = -1;
                            return;
                          }
                          touchedBarIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipPadding: EdgeInsets.all(2.w),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final data = widget.trendData[groupIndex];
                            return BarTooltipItem(
                                '${data['category']}\n\$${(data['amount'] as double).toStringAsFixed(2)}',
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
                                    value.toInt() < widget.trendData.length) {
                                  final data = widget.trendData[value.toInt()];
                                  final category = data['category'] as String;
                                  return Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Transform.rotate(
                                          angle: -0.5,
                                          child: Text(
                                              category.length > 8
                                                  ? '${category.substring(0, 8)}...'
                                                  : category,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withValues(
                                                              alpha: 0.6),
                                                      fontSize: 10),
                                              textAlign: TextAlign.center)));
                                }
                                return const Text('');
                              },
                              reservedSize: 6.h)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 12.w,
                              interval: _getMaxValue() / 5,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == 0) return const Text('');
                                return Text(
                                    value >= 1000
                                        ? '\$${(value / 1000).toStringAsFixed(1)}k'
                                        : '\$${value.toStringAsFixed(0)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                        fontSize: 10));
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
                      horizontalInterval: _getMaxValue() / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            strokeWidth: 1);
                      })))),
          SizedBox(height: 2.h),
          _buildCategoryList(context),
        ]));
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.trendData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedBarIndex;
      final amount = data['amount'] as double;

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: amount,
            color: Color(data['color'] as int),
            width: isTouched ? 6.w : 4.w,
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(colors: [
              Color(data['color'] as int),
              Color(data['color'] as int).withValues(alpha: 0.7),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ]);
    }).toList();
  }

  Widget _buildCategoryList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort by amount descending for the list
    final sortedData = List<Map<String, dynamic>>.from(widget.trendData)
      ..sort(
          (a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Top Categories',
          style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600)),
      SizedBox(height: 1.h),
      ...sortedData.take(5).map((data) {
        final amount = data['amount'] as double;
        final maxAmount = sortedData.first['amount'] as double;
        final percentage = (amount / maxAmount);

        return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Row(children: [
              Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                      color: Color(data['color'] as int),
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['category'] as String,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis),
                          Text('\$${amount.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.getErrorColor(
                                      theme.brightness == Brightness.light))),
                        ]),
                    SizedBox(height: 0.5.h),
                    LinearProgressIndicator(
                        value: percentage,
                        backgroundColor:
                            colorScheme.outline.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(data['color'] as int)),
                        minHeight: 1.5),
                  ])),
            ]));
      }).toList(),
    ]);
  }

  double _getMaxValue() {
    if (widget.trendData.isEmpty) return 0;
    return widget.trendData
        .map((data) => data['amount'] as double)
        .reduce((a, b) => a > b ? a : b);
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
              iconName: 'trending_up',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 48),
          SizedBox(height: 2.h),
          Text('No Trend Data',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6))),
          SizedBox(height: 1.h),
          Text('Add more transactions to see spending trends',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center),
        ]));
  }
}
