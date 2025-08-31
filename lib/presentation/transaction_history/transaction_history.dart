import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bulk_action_bar.dart';
import './widgets/date_range_picker_widget.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/transaction_list_widget.dart';
import './widgets/transaction_search_bar.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  // Search and filter state
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  DateRangePreset _selectedPreset = DateRangePreset.month;
  List<String> _selectedCategories = [];
  double? _minAmount;
  double? _maxAmount;
  String? _selectedType;

  // List state
  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  bool _isLoading = false;
  bool _hasMore = true;

  // Selection state
  bool _isSelectionMode = false;
  Set<String> _selectedTransactions = {};

  // Controllers
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
    _setInitialDateRange();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  void _setInitialDateRange() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    setState(() {
      _selectedDateRange = DateTimeRange(start: monthStart, end: monthEnd);
    });

    _applyFilters();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Mock transaction data
    _allTransactions = [
      {
        "id": "1",
        "description": "Grocery Shopping at Walmart",
        "amount": 85.50,
        "type": "expense",
        "category": "Food",
        "date": "2025-08-15T10:30:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "2",
        "description": "Salary Payment",
        "amount": 3500.00,
        "type": "income",
        "category": "Salary",
        "date": "2025-08-15T09:00:00.000Z",
        "hasReceipt": false,
      },
      {
        "id": "3",
        "description": "Gas Station Fill-up",
        "amount": 45.20,
        "type": "expense",
        "category": "Transport",
        "date": "2025-08-14T18:45:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "4",
        "description": "Netflix Subscription",
        "amount": 15.99,
        "type": "expense",
        "category": "Entertainment",
        "date": "2025-08-14T12:00:00.000Z",
        "hasReceipt": false,
      },
      {
        "id": "5",
        "description": "Coffee at Starbucks",
        "amount": 4.75,
        "type": "expense",
        "category": "Food",
        "date": "2025-08-14T08:15:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "6",
        "description": "Freelance Project Payment",
        "amount": 750.00,
        "type": "income",
        "category": "Business",
        "date": "2025-08-13T16:30:00.000Z",
        "hasReceipt": false,
      },
      {
        "id": "7",
        "description": "Electric Bill Payment",
        "amount": 120.45,
        "type": "expense",
        "category": "Bills",
        "date": "2025-08-13T14:20:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "8",
        "description": "Amazon Purchase",
        "amount": 67.89,
        "type": "expense",
        "category": "Shopping",
        "date": "2025-08-12T20:10:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "9",
        "description": "Doctor Visit",
        "amount": 150.00,
        "type": "expense",
        "category": "Health",
        "date": "2025-08-12T11:00:00.000Z",
        "hasReceipt": true,
      },
      {
        "id": "10",
        "description": "Investment Dividend",
        "amount": 125.30,
        "type": "income",
        "category": "Investment",
        "date": "2025-08-11T10:00:00.000Z",
        "hasReceipt": false,
      },
    ];

    setState(() {
      _isLoading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allTransactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final description =
            (transaction['description'] as String).toLowerCase();
        final category = (transaction['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return description.contains(query) || category.contains(query);
      }).toList();
    }

    // Apply date range filter
    if (_selectedDateRange != null) {
      filtered = filtered.where((transaction) {
        final transactionDate = DateTime.parse(transaction['date'] as String);
        return transactionDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            transactionDate
                .isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return _selectedCategories.contains(transaction['category'] as String);
      }).toList();
    }

    // Apply amount range filter
    if (_minAmount != null) {
      filtered = filtered.where((transaction) {
        return (transaction['amount'] as double) >= _minAmount!;
      }).toList();
    }

    if (_maxAmount != null) {
      filtered = filtered.where((transaction) {
        return (transaction['amount'] as double) <= _maxAmount!;
      }).toList();
    }

    // Apply transaction type filter
    if (_selectedType != null && _selectedType != 'All') {
      filtered = filtered.where((transaction) {
        return (transaction['type'] as String).toLowerCase() ==
            _selectedType!.toLowerCase();
      }).toList();
    }

    // Sort by date descending
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['date'] as String);
      final dateB = DateTime.parse(b['date'] as String);
      return dateB.compareTo(dateA);
    });

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          if (!_isSelectionMode)
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
                  value: 'export_excel',
                  child: Row(
                    children: [
                      Icon(Icons.table_chart_outlined),
                      SizedBox(width: 12),
                      Text('Export Excel'),
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
      ),
      body: Column(
        children: [
          // Search Bar
          TransactionSearchBar(
            searchQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _applyFilters();
            },
            onVoiceSearch: _handleVoiceSearch,
          ),

          // Date Range Picker
          DateRangePickerWidget(
            selectedRange: _selectedDateRange,
            selectedPreset: _selectedPreset,
            onRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
              _applyFilters();
            },
            onPresetChanged: (preset) {
              setState(() {
                _selectedPreset = preset;
              });
            },
          ),

          // Transaction List
          Expanded(
            child: TransactionListWidget(
              transactions: _filteredTransactions,
              searchQuery: _searchQuery,
              isLoading: _isLoading,
              hasMore: _hasMore,
              onLoadMore: _loadMoreTransactions,
              onRefresh: _refreshTransactions,
              onTransactionTap: _handleTransactionTap,
              onTransactionEdit: _handleTransactionEdit,
              onTransactionDelete: _handleTransactionDelete,
              onTransactionDuplicate: _handleTransactionDuplicate,
              onTransactionShare: _handleTransactionShare,
              onReceiptView: _handleReceiptView,
              isSelectionMode: _isSelectionMode,
              selectedTransactions: _selectedTransactions,
              onTransactionSelected: _handleTransactionSelection,
            ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                onPressed: _showFilterBottomSheet,
                tooltip: 'Filter transactions',
                child: CustomIconWidget(
                  iconName: 'filter_list',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
      bottomNavigationBar: _isSelectionMode
          ? BulkActionBar(
              selectedCount: _selectedTransactions.length,
              onSelectAll: _selectAllTransactions,
              onDeselectAll: _deselectAllTransactions,
              onBulkDelete: _handleBulkDelete,
              onBulkExport: _handleBulkExport,
              onBulkShare: _handleBulkShare,
              onCancel: _exitSelectionMode,
            )
          : null,
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_pdf':
        _exportToPDF();
        break;
      case 'export_excel':
        _exportToExcel();
        break;
      case 'share':
        _shareReport();
        break;
    }
  }

  void _handleVoiceSearch() {
    // Voice search implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _loadMoreTransactions() {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more transactions
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _hasMore = false; // No more data for demo
      });
    });
  }

  void _refreshTransactions() {
    _loadInitialData();
  }

  void _handleTransactionTap(Map<String, dynamic> transaction) {
    if (_isSelectionMode) {
      _handleTransactionSelection(transaction['id'] as String,
          !_selectedTransactions.contains(transaction['id'] as String));
    } else {
      // Navigate to transaction details or show details modal
      _showTransactionDetails(transaction);
    }
  }

  void _handleTransactionEdit(Map<String, dynamic> transaction) {
    Navigator.pushNamed(
      context,
      '/add-transaction',
      arguments: {'transaction': transaction, 'isEdit': true},
    );
  }

  void _handleTransactionDelete(Map<String, dynamic> transaction) {
    setState(() {
      _allTransactions.removeWhere((t) => t['id'] == transaction['id']);
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction "${transaction['description']}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allTransactions.add(transaction);
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _handleTransactionDuplicate(Map<String, dynamic> transaction) {
    final duplicatedTransaction = Map<String, dynamic>.from(transaction);
    duplicatedTransaction['id'] =
        DateTime.now().millisecondsSinceEpoch.toString();
    duplicatedTransaction['date'] = DateTime.now().toIso8601String();

    setState(() {
      _allTransactions.insert(0, duplicatedTransaction);
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction duplicated successfully'),
      ),
    );
  }

  void _handleTransactionShare(Map<String, dynamic> transaction) {
    final shareText = '''
Transaction Details:
Description: ${transaction['description']}
Amount: \$${(transaction['amount'] as double).toStringAsFixed(2)}
Type: ${transaction['type']}
Category: ${transaction['category']}
Date: ${DateTime.parse(transaction['date'] as String).toString().split(' ')[0]}
''';

    // Share implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction shared successfully'),
      ),
    );
  }

  void _handleReceiptView(Map<String, dynamic> transaction) {
    Navigator.pushNamed(
      context,
      '/receipt-viewer',
      arguments: {'transaction': transaction},
    );
  }

  void _handleTransactionSelection(String transactionId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedTransactions.add(transactionId);
        if (!_isSelectionMode) {
          _isSelectionMode = true;
        }
      } else {
        _selectedTransactions.remove(transactionId);
        if (_selectedTransactions.isEmpty) {
          _isSelectionMode = false;
        }
      }
    });
  }

  void _selectAllTransactions() {
    setState(() {
      _selectedTransactions =
          _filteredTransactions.map((t) => t['id'] as String).toSet();
    });
  }

  void _deselectAllTransactions() {
    setState(() {
      _selectedTransactions.clear();
      _isSelectionMode = false;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectedTransactions.clear();
      _isSelectionMode = false;
    });
  }

  void _handleBulkDelete() {
    final selectedIds = Set.from(_selectedTransactions);
    final deletedTransactions =
        _allTransactions.where((t) => selectedIds.contains(t['id'])).toList();

    setState(() {
      _allTransactions.removeWhere((t) => selectedIds.contains(t['id']));
      _selectedTransactions.clear();
      _isSelectionMode = false;
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedTransactions.length} transactions deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allTransactions.addAll(deletedTransactions);
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _handleBulkExport() {
    final selectedTransactions = _allTransactions
        .where((t) => _selectedTransactions.contains(t['id']))
        .toList();

    _exportTransactions(selectedTransactions);
    _exitSelectionMode();
  }

  void _handleBulkShare() {
    final selectedTransactions = _allTransactions
        .where((t) => _selectedTransactions.contains(t['id']))
        .toList();

    _shareTransactions(selectedTransactions);
    _exitSelectionMode();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 80.h,
        child: FilterBottomSheet(
          selectedCategories: _selectedCategories,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
          selectedType: _selectedType,
          onApplyFilters: (categories, minAmount, maxAmount, type) {
            setState(() {
              _selectedCategories = categories;
              _minAmount = minAmount;
              _maxAmount = maxAmount;
              _selectedType = type;
            });
            _applyFilters();
          },
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Transaction Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
                'Description', transaction['description'] as String),
            _buildDetailRow('Amount',
                '\$${(transaction['amount'] as double).toStringAsFixed(2)}'),
            _buildDetailRow('Type', transaction['type'] as String),
            _buildDetailRow('Category', transaction['category'] as String),
            _buildDetailRow(
                'Date',
                DateTime.parse(transaction['date'] as String)
                    .toString()
                    .split(' ')[0]),
            _buildDetailRow(
                'Receipt',
                (transaction['hasReceipt'] as bool)
                    ? 'Available'
                    : 'Not available'),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting to PDF...'),
      ),
    );
  }

  void _exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting to Excel...'),
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing report...'),
      ),
    );
  }

  void _exportTransactions(List<Map<String, dynamic>> transactions) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${transactions.length} transactions...'),
      ),
    );
  }

  void _shareTransactions(List<Map<String, dynamic>> transactions) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${transactions.length} transactions...'),
      ),
    );
  }
}
