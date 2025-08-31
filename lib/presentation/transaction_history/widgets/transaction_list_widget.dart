import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './transaction_card_widget.dart';

class TransactionListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final String searchQuery;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRefresh;
  final Function(Map<String, dynamic>)? onTransactionTap;
  final Function(Map<String, dynamic>)? onTransactionEdit;
  final Function(Map<String, dynamic>)? onTransactionDelete;
  final Function(Map<String, dynamic>)? onTransactionDuplicate;
  final Function(Map<String, dynamic>)? onTransactionShare;
  final Function(Map<String, dynamic>)? onReceiptView;
  final bool isSelectionMode;
  final Set<String> selectedTransactions;
  final Function(String, bool)? onTransactionSelected;

  const TransactionListWidget({
    super.key,
    required this.transactions,
    this.searchQuery = '',
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.onRefresh,
    this.onTransactionTap,
    this.onTransactionEdit,
    this.onTransactionDelete,
    this.onTransactionDuplicate,
    this.onTransactionShare,
    this.onReceiptView,
    this.isSelectionMode = false,
    this.selectedTransactions = const {},
    this.onTransactionSelected,
  });

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.transactions.isEmpty && !widget.isLoading) {
      return _buildEmptyState(context);
    }

    final groupedTransactions = _groupTransactionsByDate(widget.transactions);

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      color: colorScheme.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ...groupedTransactions.entries.map((entry) {
            final date = entry.key;
            final transactions = entry.value;

            return SliverMainAxisGroup(
              slivers: [
                // Date Header
                SliverToBoxAdapter(
                  child: _buildDateHeader(context, date, transactions),
                ),
                // Transactions for this date
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionItem(context, transaction);
                    },
                    childCount: transactions.length,
                  ),
                ),
              ],
            );
          }).toList(),

          // Loading indicator
          if (widget.isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date,
      List<Map<String, dynamic>> transactions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalIncome = transactions
        .where((t) => (t['type'] as String).toLowerCase() == 'income')
        .fold<double>(0, (sum, t) => sum + (t['amount'] as double));

    final totalExpense = transactions
        .where((t) => (t['type'] as String).toLowerCase() == 'expense')
        .fold<double>(0, (sum, t) => sum + (t['amount'] as double));

    return Container(
      margin: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
                iconName: 'calendar_today',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                _formatDateHeader(date),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${transactions.length} transaction${transactions.length != 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          if (totalIncome > 0 || totalExpense > 0) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                if (totalIncome > 0) ...[
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '+\$${totalIncome.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (totalIncome > 0 && totalExpense > 0) ...[
                  SizedBox(width: 4.w),
                  Container(
                    width: 1,
                    height: 16,
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  SizedBox(width: 4.w),
                ],
                if (totalExpense > 0) ...[
                  CustomIconWidget(
                    iconName: 'trending_down',
                    color: AppTheme.getErrorColor(
                        theme.brightness == Brightness.light),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '-\$${totalExpense.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getErrorColor(
                          theme.brightness == Brightness.light),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Map<String, dynamic> transaction) {
    final transactionId = transaction['id'] as String;
    final isSelected = widget.selectedTransactions.contains(transactionId);

    if (widget.isSelectionMode) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            TransactionCardWidget(
              transaction: transaction,
              searchQuery: widget.searchQuery,
              onTap: () => widget.onTransactionSelected
                  ?.call(transactionId, !isSelected),
              onEdit: () => widget.onTransactionEdit?.call(transaction),
              onDelete: () => widget.onTransactionDelete?.call(transaction),
              onDuplicate: () =>
                  widget.onTransactionDuplicate?.call(transaction),
              onShare: () => widget.onTransactionShare?.call(transaction),
              onReceiptView: () => widget.onReceiptView?.call(transaction),
            ),
            Positioned(
              top: 2.w,
              right: 2.w,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isSelected
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
          ],
        ),
      );
    }

    return TransactionCardWidget(
      transaction: transaction,
      searchQuery: widget.searchQuery,
      onTap: () => widget.onTransactionTap?.call(transaction),
      onEdit: () => widget.onTransactionEdit?.call(transaction),
      onDelete: () => widget.onTransactionDelete?.call(transaction),
      onDuplicate: () => widget.onTransactionDuplicate?.call(transaction),
      onShare: () => widget.onTransactionShare?.call(transaction),
      onReceiptView: () => widget.onReceiptView?.call(transaction),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String title;
    String subtitle;
    String iconName;

    if (widget.searchQuery.isNotEmpty) {
      title = 'No Results Found';
      subtitle = 'Try adjusting your search terms or filters';
      iconName = 'search_off';
    } else {
      title = 'No Transactions Yet';
      subtitle = 'Start by adding your first transaction';
      iconName = 'receipt_long';
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: colorScheme.primary.withValues(alpha: 0.7),
                  size: 48,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.searchQuery.isEmpty) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/add-transaction'),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate(
    List<Map<String, dynamic>> transactions,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final transaction in transactions) {
      final date = DateTime.parse(transaction['date'] as String);
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    // Sort by date descending
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Map.fromEntries(sortedEntries);
  }

  String _formatDateHeader(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}
