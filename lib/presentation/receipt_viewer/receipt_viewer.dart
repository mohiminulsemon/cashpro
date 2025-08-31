import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

/// Receipt Viewer screen for full-screen image viewing and management
class ReceiptViewer extends StatefulWidget {
  const ReceiptViewer({super.key});

  @override
  State<ReceiptViewer> createState() => _ReceiptViewerState();
}

class _ReceiptViewerState extends State<ReceiptViewer> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _showOverlay = true;
  bool _isLoading = false;

  // Mock receipt data - in real app, this would come from arguments or state management
  final List<Map<String, dynamic>> _receiptData = [
    {
      "id": "receipt_001",
      "imageUrl":
          "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "transactionData": {
        "id": "txn_001",
        "amount": 125.50,
        "type": "expense",
        "category": "Groceries",
        "description": "Weekly grocery shopping at SuperMart",
        "date": "2025-08-14T10:30:00.000Z",
        "receiptCount": 2,
      }
    },
    {
      "id": "receipt_002",
      "imageUrl":
          "https://images.unsplash.com/photo-1586953208448-b95a79798f07?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "transactionData": {
        "id": "txn_001",
        "amount": 125.50,
        "type": "expense",
        "category": "Groceries",
        "description": "Weekly grocery shopping at SuperMart - Page 2",
        "date": "2025-08-14T10:30:00.000Z",
        "receiptCount": 2,
      }
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setSystemUIOverlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _resetSystemUIOverlay();
    super.dispose();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
  }

  void _resetSystemUIOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  void _handleShare() {
    // In real app, implement platform-specific sharing
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Receipt shared successfully',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }

  void _handleDelete() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Receipt',
                    style: Theme.of(context).textTheme.titleLarge),
                content: Text(
                    'Are you sure you want to permanently delete this receipt? This action cannot be undone.',
                    style: Theme.of(context).textTheme.bodyMedium),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6)))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _performDelete();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.getErrorColor(
                              Theme.of(context).brightness == Brightness.light),
                          foregroundColor: Colors.white),
                      child: Text('Delete',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                ]));
  }

  void _performDelete() {
    setState(() {
      _isLoading = true;
    });

    // Simulate delete operation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Receipt deleted successfully',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white)),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))));
        Navigator.of(context).pop();
      }
    });
  }

  void _handleReCapture() {
    // In real app, open camera interface
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opening camera to re-capture receipt...',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }

  void _handleEditTransaction() {
    Navigator.pushNamed(context, '/add-transaction', arguments: {
      'transactionId': _receiptData[_currentPage]['transactionData']['id'],
      'editMode': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentReceipt = _receiptData[_currentPage];
    final transactionData =
        currentReceipt['transactionData'] as Map<String, dynamic>;

    return Scaffold(backgroundColor: Colors.black, body: Stack());
  }
}
