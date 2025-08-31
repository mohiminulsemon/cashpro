import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SummaryMetricsCards extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const SummaryMetricsCards({
    super.key,
    required this.metricsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Highest Category',
                  metricsData['highestCategory'] as String? ?? 'N/A',
                  '\$${(metricsData['highestCategoryAmount'] as double? ?? 0.0).toStringAsFixed(2)}',
                  'trending_up',
                  AppTheme.getErrorColor(theme.brightness == Brightness.light),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Daily Average',
                  'Spending',
                  '\$${(metricsData['averageDailySpending'] as double? ?? 0.0).toStringAsFixed(2)}',
                  'calendar_today',
                  colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Monthly Change',
                  _getChangeText(
                      metricsData['monthlyChange'] as double? ?? 0.0),
                  '${(metricsData['monthlyChange'] as double? ?? 0.0) >= 0 ? '+' : ''}${(metricsData['monthlyChange'] as double? ?? 0.0).toStringAsFixed(1)}%',
                  (metricsData['monthlyChange'] as double? ?? 0.0) >= 0
                      ? 'trending_up'
                      : 'trending_down',
                  (metricsData['monthlyChange'] as double? ?? 0.0) >= 0
                      ? AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light)
                      : AppTheme.getErrorColor(
                          theme.brightness == Brightness.light),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Total Transactions',
                  'This Period',
                  '${metricsData['totalTransactions'] as int? ?? 0}',
                  'receipt_long',
                  AppTheme.getWarningColor(
                      theme.brightness == Brightness.light),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    String iconName,
    Color accentColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: accentColor,
                  size: 16,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getChangeText(double change) {
    if (change > 0) {
      return 'Increase';
    } else if (change < 0) {
      return 'Decrease';
    } else {
      return 'No Change';
    }
  }
}
