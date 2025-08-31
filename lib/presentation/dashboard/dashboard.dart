import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/account_balance_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/metrics_card.dart';
import './widgets/quick_add_bottom_sheet.dart';
import './widgets/recent_transaction_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool _isPrivacyMode = false;
  String _currentAccount = 'Personal';
  bool _isRefreshing = false;
  bool _isOffline = false;
  DateTime _lastUpdate = DateTime.now();

  // Mock data - in real app this would come from Firestore
  final List<Map<String, dynamic>> _mockTransactions = [
    {
      'id': '1',
      'type': 'expense',
      'amount': 45.50,
      'category': 'Food',
      'description': 'Lunch at downtown cafe',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'type': 'income',
      'amount': 2500.00,
      'category': 'Salary',
      'description': 'Monthly salary deposit',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'type': 'expense',
      'amount': 89.99,
      'category': 'Shopping',
      'description': 'Online shopping - electronics',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '4',
      'type': 'expense',
      'amount': 25.00,
      'category': 'Transport',
      'description': 'Gas station fill-up',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': '5',
      'type': 'income',
      'amount': 150.00,
      'category': 'Freelance',
      'description': 'Website design project',
      'date': DateTime.now().subtract(const Duration(days: 4)),
    },
  ];

  double get _currentBalance {
    double balance = 0.0;
    for (var transaction in _mockTransactions) {
      final amount = (transaction['amount'] as num).toDouble();
      if (transaction['type'] == 'income') {
        balance += amount;
      } else {
        balance -= amount;
      }
    }
    return balance + 1500.0; // Starting balance
  }

  double get _todayExpenses {
    final today = DateTime.now();
    return _mockTransactions
        .where((t) =>
            t['type'] == 'expense' && _isSameDay(t['date'] as DateTime, today))
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double get _monthlyIncome {
    final now = DateTime.now();
    return _mockTransactions
        .where((t) =>
            t['type'] == 'income' &&
            (t['date'] as DateTime).month == now.month &&
            (t['date'] as DateTime).year == now.year)
        .fold(0.0, (sum, t) => sum + (t['amount'] as num).toDouble());
  }

  double get _pendingCredits {
    // Mock pending credits calculation
    return 320.50;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentIndex = CustomBottomBar.getIndexFromRoute('/dashboard');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar.dashboard(
        actions: [
          IconButton(
            onPressed: _showAccountSwitcher,
            icon: CustomIconWidget(
              iconName: 'swap_horiz',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Switch Account',
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-settings'),
            icon: CustomIconWidget(
              iconName: 'account_circle_outlined',
              color: colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: _mockTransactions.isEmpty
          ? EmptyStateWidget(onAddFirstTransaction: _showQuickAddSheet)
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isOffline) _buildOfflineIndicator(),

                    // Account Balance Card
                    AccountBalanceCard(
                      balance: _currentBalance,
                      accountType: _currentAccount,
                      isPrivacyMode: _isPrivacyMode,
                      onPrivacyToggle: () =>
                          setState(() => _isPrivacyMode = !_isPrivacyMode),
                      onAccountSwitch: _showAccountSwitcher,
                    ),

                    // Metrics Cards
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overview',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: 20.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                MetricsCard(
                                  title: 'Today\'s Expenses',
                                  amount:
                                      '\$${_todayExpenses.toStringAsFixed(2)}',
                                  iconName: 'trending_down',
                                  iconColor: AppTheme.getErrorColor(
                                      theme.brightness == Brightness.light),
                                  backgroundColor: colorScheme.surface,
                                  onTap: () =>
                                      _showMetricDetails('Today\'s Expenses'),
                                  onLongPress: () =>
                                      _showMetricBreakdown('expenses'),
                                ),
                                MetricsCard(
                                  title: 'Monthly Income',
                                  amount:
                                      '\$${_monthlyIncome.toStringAsFixed(2)}',
                                  iconName: 'trending_up',
                                  iconColor: AppTheme.getSuccessColor(
                                      theme.brightness == Brightness.light),
                                  backgroundColor: colorScheme.surface,
                                  onTap: () =>
                                      _showMetricDetails('Monthly Income'),
                                  onLongPress: () =>
                                      _showMetricBreakdown('income'),
                                ),
                                MetricsCard(
                                  title: 'Pending Credits',
                                  amount:
                                      '\$${_pendingCredits.toStringAsFixed(2)}',
                                  iconName: 'schedule',
                                  iconColor: AppTheme.getWarningColor(
                                      theme.brightness == Brightness.light),
                                  backgroundColor: colorScheme.surface,
                                  onTap: () =>
                                      _showMetricDetails('Pending Credits'),
                                  onLongPress: () =>
                                      _showMetricBreakdown('credits'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Recent Transactions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/transaction-history'),
                                child: Text(
                                  'View All',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _mockTransactions.take(5).length,
                            itemBuilder: (context, index) {
                              final transaction = _mockTransactions[index];
                              return RecentTransactionItem(
                                transaction: transaction,
                                onTap: () =>
                                    _showTransactionDetails(transaction),
                                onEdit: () => _editTransaction(transaction),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for FAB
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickAddSheet,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: currentIndex,
        onTap: (index) {
          // Handle navigation
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              Navigator.pushNamed(context, '/add-transaction');
              break;
            case 2:
              Navigator.pushNamed(context, '/transaction-history');
              break;
            case 3:
              Navigator.pushNamed(context, '/reports');
              break;
          }
        },
      ),
    );
  }

  Widget _buildOfflineIndicator() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      color: AppTheme.getWarningColor(theme.brightness == Brightness.light)
          .withValues(alpha: 0.1),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'cloud_off',
            color:
                AppTheme.getWarningColor(theme.brightness == Brightness.light),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Offline mode • Last sync: ${_formatLastUpdate()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getWarningColor(
                    theme.brightness == Brightness.light),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdate);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);

    // Simulate Firestore sync
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdate = DateTime.now();
      _isOffline = false; // Assume successful sync
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data synced successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickAddBottomSheet(
        onTransactionAdded: (transaction) {
          setState(() {
            _mockTransactions.insert(0, transaction);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully')),
          );
        },
      ),
    );
  }

  void _showAccountSwitcher() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Account',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Personal Account'),
                subtitle: Text('\$${_currentBalance.toStringAsFixed(2)}'),
                trailing: _currentAccount == 'Personal'
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  setState(() => _currentAccount = 'Personal');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'business',
                  color: colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Business Account'),
                subtitle: const Text('\$5,420.75'),
                trailing: _currentAccount == 'Business'
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  setState(() => _currentAccount = 'Business');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showMetricDetails(String title) {
    Navigator.pushNamed(context, '/reports');
  }

  void _showMetricBreakdown(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${type.toUpperCase()} Breakdown'),
        content: Text('Detailed breakdown for $type will be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction['description'] ?? 'Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Amount: \$${(transaction['amount'] as num).toStringAsFixed(2)}'),
            Text('Category: ${transaction['category']}'),
            Text('Type: ${transaction['type']}'),
            Text(
                'Date: ${_formatTransactionDate(transaction['date'] as DateTime)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editTransaction(transaction);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    Navigator.pushNamed(context, '/add-transaction');
  }

  String _formatTransactionDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
