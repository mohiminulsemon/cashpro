import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_picker_widget.dart';
import './widgets/credit_udhaar_toggle_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/quick_templates_widget.dart';
import './widgets/receipt_attachment_widget.dart';
import './widgets/transaction_type_toggle_widget.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form state
  TransactionType _selectedType = TransactionType.expense;
  CategoryData? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  XFile? _attachedReceipt;
  bool _isCreditTransaction = false;
  String _debtorCreditorName = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0 &&
        _selectedCategory != null &&
        _descriptionController.text.trim().isNotEmpty &&
        (!_isCreditTransaction || _debtorCreditorName.trim().isNotEmpty);
  }

  void _handleTemplateSelection(QuickTemplate template) {
    setState(() {
      _amountController.text = template.amount;
      _descriptionController.text = template.description;
      _selectedCategory = CategoryData(
        id: template.categoryId,
        name: template.name,
        iconName: template.iconName,
        color: template.color,
        isIncome: template.isIncome,
      );
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _saveTransaction() async {
    if (!_isFormValid) {
      _showValidationError();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to save transaction
      await Future.delayed(const Duration(seconds: 2));

      // Show success feedback
      HapticFeedback.mediumImpact();
      _showSuccessMessage();

      // Navigate back to dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } catch (e) {
      _showErrorMessage('Failed to save transaction. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showValidationError() {
    String message = 'Please fill in all required fields:';
    List<String> errors = [];

    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      errors.add('• Valid amount');
    }
    if (_selectedCategory == null) {
      errors.add('• Category');
    }
    if (_descriptionController.text.trim().isEmpty) {
      errors.add('• Description');
    }
    if (_isCreditTransaction && _debtorCreditorName.trim().isEmpty) {
      errors.add(
          '• ${_selectedType == TransactionType.income ? 'Debtor' : 'Creditor'} name');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Information'),
        content: Text('$message\n\n${errors.join('\n')}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              'Transaction saved successfully!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.getErrorColor(
            Theme.of(context).brightness == Brightness.light),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    final hasChanges = _amountController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _selectedCategory != null ||
        _attachedReceipt != null ||
        _isCreditTransaction;

    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: Text(
              'Leave',
              style: TextStyle(
                color: AppTheme.getErrorColor(
                    Theme.of(context).brightness == Brightness.light),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Add Transaction',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          leading: IconButton(
            onPressed: _showUnsavedChangesDialog,
            icon: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_isFormValid)
              TextButton(
                onPressed: _isLoading ? null : _saveTransaction,
                child: Text(
                  'Save',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Input
                      AmountInputWidget(
                        controller: _amountController,
                        onAmountChanged: (amount) {
                          setState(() {});
                        },
                        currency: '\$',
                      ),
                      SizedBox(height: 3.h),

                      // Transaction Type Toggle
                      TransactionTypeToggleWidget(
                        selectedType: _selectedType,
                        onTypeChanged: (type) {
                          setState(() {
                            _selectedType = type;
                            _selectedCategory =
                                null; // Reset category when type changes
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Quick Templates
                      QuickTemplatesWidget(
                        onTemplateSelected: _handleTemplateSelection,
                        isIncomeType: _selectedType == TransactionType.income,
                      ),
                      SizedBox(height: 3.h),

                      // Category Picker
                      CategoryPickerWidget(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        isIncomeType: _selectedType == TransactionType.income,
                      ),
                      SizedBox(height: 3.h),

                      // Description Input
                      DescriptionInputWidget(
                        controller: _descriptionController,
                        onDescriptionChanged: (description) {
                          setState(() {});
                        },
                        isIncomeType: _selectedType == TransactionType.income,
                      ),
                      SizedBox(height: 3.h),

                      // Date Picker
                      DatePickerWidget(
                        selectedDate: _selectedDate,
                        onDateChanged: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Receipt Attachment
                      ReceiptAttachmentWidget(
                        attachedReceipt: _attachedReceipt,
                        onReceiptChanged: (receipt) {
                          setState(() {
                            _attachedReceipt = receipt;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Credit/Udhaar Toggle (Business accounts only)
                      CreditUdhaarToggleWidget(
                        isCreditTransaction: _isCreditTransaction,
                        onCreditToggleChanged: (isCredit) {
                          setState(() {
                            _isCreditTransaction = isCredit;
                            if (!isCredit) {
                              _debtorCreditorName = '';
                            }
                          });
                        },
                        debtorCreditorName: _debtorCreditorName.isEmpty
                            ? null
                            : _debtorCreditorName,
                        onDebtorCreditorNameChanged: (name) {
                          setState(() {
                            _debtorCreditorName = name;
                          });
                        },
                        isIncomeType: _selectedType == TransactionType.income,
                      ),
                      SizedBox(height: 10.h), // Extra space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _isFormValid
            ? FloatingActionButton.extended(
                onPressed: _isLoading ? null : _saveTransaction,
                backgroundColor: _isLoading
                    ? colorScheme.outline.withValues(alpha: 0.3)
                    : colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'save',
                        color: Colors.white,
                        size: 20,
                      ),
                label: Text(
                  _isLoading ? 'Saving...' : 'Save Transaction',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
