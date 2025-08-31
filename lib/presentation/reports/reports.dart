import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_filter_dropdown.dart';
import './widgets/category_spending_trends.dart';
import './widgets/date_range_selector.dart';
import './widgets/expense_breakdown_chart.dart';
import './widgets/export_section.dart';
import './widgets/income_expense_comparison_chart.dart';
import './widgets/summary_metrics_cards.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPreset = 'This Month';
  String _selectedAccount = 'all';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;

  // Mock data for reports
  final List<String> _presetOptions = [
    'This Week',
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
    'Custom'
  ];

  final List<Map<String, dynamic>> _accounts = [
    {
      'id': 'all',
      'name': 'All Accounts',
      'type': 'Combined',
      'balance': 15420.50,
      'color': 0xFF2563EB,
    },
    {
      'id': 'personal',
      'name': 'Personal Account',
      'type': 'Personal',
      'balance': 8750.25,
      'color': 0xFF059669,
    },
    {
      'id': 'business',
      'name': 'Business Account',
      'type': 'Business',
      'balance': 6670.25,
      'color': 0xFFD97706,
    },
  ];

  final List<Map<String, dynamic>> _expenseBreakdownData = [
    {
      'category': 'Food & Dining',
      'amount': 1250.75,
      'color': 0xFFEF4444,
    },
    {
      'category': 'Transportation',
      'amount': 850.50,
      'color': 0xFF3B82F6,
    },
    {
      'category': 'Shopping',
      'amount': 675.25,
      'color': 0xFF8B5CF6,
    },
    {
      'category': 'Entertainment',
      'amount': 425.00,
      'color': 0xFFF59E0B,
    },
    {
      'category': 'Utilities',
      'amount': 320.75,
      'color': 0xFF10B981,
    },
    {
      'category': 'Healthcare',
      'amount': 280.50,
      'color': 0xFFEC4899,
    },
  ];

  final List<Map<String, dynamic>> _comparisonData = [
    {
      'period': 'Week 1',
      'income': 2500.00,
      'expense': 1850.75,
    },
    {
      'period': 'Week 2',
      'income': 3200.50,
      'expense': 2100.25,
    },
    {
      'period': 'Week 3',
      'income': 2800.75,
      'expense': 1950.50,
    },
    {
      'period': 'Week 4',
      'income': 3500.25,
      'expense': 2250.00,
    },
  ];

  final List<Map<String, dynamic>> _trendData = [
    {
      'category': 'Food',
      'amount': 1250.75,
      'color': 0xFFEF4444,
    },
    {
      'category': 'Transport',
      'amount': 850.50,
      'color': 0xFF3B82F6,
    },
    {
      'category': 'Shopping',
      'amount': 675.25,
      'color': 0xFF8B5CF6,
    },
    {
      'category': 'Entertainment',
      'amount': 425.00,
      'color': 0xFFF59E0B,
    },
    {
      'category': 'Utilities',
      'amount': 320.75,
      'color': 0xFF10B981,
    },
    {
      'category': 'Healthcare',
      'amount': 280.50,
      'color': 0xFFEC4899,
    },
    {
      'category': 'Education',
      'amount': 180.25,
      'color': 0xFF06B6D4,
    },
  ];

  final Map<String, dynamic> _metricsData = {
    'highestCategory': 'Food & Dining',
    'highestCategoryAmount': 1250.75,
    'averageDailySpending': 125.50,
    'monthlyChange': 8.5,
    'totalTransactions': 147,
  };

  final Map<String, dynamic> _reportData = {
    'totalIncome': 12000.50,
    'totalExpenses': 3802.75,
    'expenseBreakdown': [
      {'category': 'Food & Dining', 'amount': 1250.75},
      {'category': 'Transportation', 'amount': 850.50},
      {'category': 'Shopping', 'amount': 675.25},
      {'category': 'Entertainment', 'amount': 425.00},
      {'category': 'Utilities', 'amount': 320.75},
      {'category': 'Healthcare', 'amount': 280.50},
    ],
    'transactions': [
      {
        'date': '2025-08-15',
        'category': 'Food & Dining',
        'type': 'Expense',
        'amount': 45.50,
        'description': 'Lunch at restaurant'
      },
      {
        'date': '2025-08-14',
        'category': 'Salary',
        'type': 'Income',
        'amount': 3000.00,
        'description': 'Monthly salary'
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReportData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Reports',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _refreshData(),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Refresh data',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined),
                    SizedBox(width: 12),
                    Text('Export PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_csv',
                child: Row(
                  children: [
                    Icon(Icons.table_chart_outlined),
                    SizedBox(width: 12),
                    Text('Export CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined),
                    SizedBox(width: 12),
                    Text('Share Report'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Analytics'),
            Tab(text: 'Export'),
          ],
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: colorScheme.primary,
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAnalyticsTab(),
                _buildExportTab(),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading report data...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          DateRangeSelector(
            startDate: _startDate,
            endDate: _endDate,
            onTap: () => _selectCustomDateRange(),
            presetOptions: _presetOptions,
            selectedPreset: _selectedPreset,
            onPresetChanged: _handlePresetChange,
          ),
          AccountFilterDropdown(
            selectedAccount: _selectedAccount,
            accounts: _accounts,
            onAccountChanged: _handleAccountChange,
          ),
          SummaryMetricsCards(metricsData: _metricsData),
          ExpenseBreakdownChart(
            expenseData: _expenseBreakdownData,
            onCategoryTap: _handleCategoryTap,
          ),
          IncomeExpenseComparisonChart(comparisonData: _comparisonData),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          DateRangeSelector(
            startDate: _startDate,
            endDate: _endDate,
            onTap: () => _selectCustomDateRange(),
            presetOptions: _presetOptions,
            selectedPreset: _selectedPreset,
            onPresetChanged: _handlePresetChange,
          ),
          AccountFilterDropdown(
            selectedAccount: _selectedAccount,
            accounts: _accounts,
            onAccountChanged: _handleAccountChange,
          ),
          CategorySpendingTrends(trendData: _trendData),
          IncomeExpenseComparisonChart(comparisonData: _comparisonData),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildExportTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          DateRangeSelector(
            startDate: _startDate,
            endDate: _endDate,
            onTap: () => _selectCustomDateRange(),
            presetOptions: _presetOptions,
            selectedPreset: _selectedPreset,
            onPresetChanged: _handlePresetChange,
          ),
          AccountFilterDropdown(
            selectedAccount: _selectedAccount,
            accounts: _accounts,
            onAccountChanged: _handleAccountChange,
          ),
          SummaryMetricsCards(metricsData: _metricsData),
          ExportSection(
            reportData: _reportData,
            startDate: _startDate,
            endDate: _endDate,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _handlePresetChange(String preset) {
    setState(() {
      _selectedPreset = preset;
      if (preset != 'Custom') {
        _updateDateRangeForPreset(preset);
      }
    });
    _loadReportData();
  }

  void _handleAccountChange(String accountId) {
    setState(() {
      _selectedAccount = accountId;
    });
    _loadReportData();
  }

  void _handleCategoryTap(String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for $category'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_pdf':
        _tabController.animateTo(2);
        break;
      case 'export_csv':
        _tabController.animateTo(2);
        break;
      case 'share':
        _tabController.animateTo(2);
        break;
    }
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
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
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedPreset = 'Custom';
      });
      _loadReportData();
    }
  }

  void _updateDateRangeForPreset(String preset) {
    final now = DateTime.now();
    switch (preset) {
      case 'This Week':
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = now;
        break;
      case 'This Month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        _startDate = lastMonth;
        _endDate = DateTime(now.year, now.month, 0);
        break;
      case 'This Quarter':
        final quarterStart =
            DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        _startDate = quarterStart;
        _endDate = now;
        break;
      case 'This Year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        break;
    }
  }

  Future<void> _loadReportData() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would fetch data based on selected filters
    // For now, we're using mock data

    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    await _loadReportData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report data refreshed'),
          backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light,
          ),
        ),
      );
    }
  }
}
