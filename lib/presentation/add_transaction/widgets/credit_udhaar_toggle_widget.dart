import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreditUdhaarToggleWidget extends StatefulWidget {
  final bool isCreditTransaction;
  final Function(bool) onCreditToggleChanged;
  final String? debtorCreditorName;
  final Function(String) onDebtorCreditorNameChanged;
  final bool isIncomeType;

  const CreditUdhaarToggleWidget({
    super.key,
    required this.isCreditTransaction,
    required this.onCreditToggleChanged,
    this.debtorCreditorName,
    required this.onDebtorCreditorNameChanged,
    required this.isIncomeType,
  });

  @override
  State<CreditUdhaarToggleWidget> createState() =>
      _CreditUdhaarToggleWidgetState();
}

class _CreditUdhaarToggleWidgetState extends State<CreditUdhaarToggleWidget> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Mock previous entries for autocomplete
  final List<String> _previousEntries = [
    'John Smith',
    'ABC Company',
    'Sarah Johnson',
    'XYZ Store',
    'Michael Brown',
    'Tech Solutions Ltd',
    'Emma Wilson',
    'Local Supplier',
    'David Lee',
    'Restaurant Partner',
  ];

  List<String> get _filteredSuggestions {
    if (_nameController.text.isEmpty) {
      return _previousEntries.take(4).toList();
    }
    return _previousEntries
        .where((name) =>
            name.toLowerCase().contains(_nameController.text.toLowerCase()))
        .take(4)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    if (widget.debtorCreditorName != null) {
      _nameController.text = widget.debtorCreditorName!;
    }

    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && widget.isCreditTransaction;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _toggleLabel =>
      widget.isIncomeType ? 'Credit (To Receive)' : 'Credit (To Pay)';
  String get _nameFieldLabel =>
      widget.isIncomeType ? 'Debtor Name' : 'Creditor Name';
  String get _nameFieldHint =>
      widget.isIncomeType ? 'Who owes you money?' : 'Who do you owe money to?';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _toggleLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: widget.isCreditTransaction,
                onChanged: (value) {
                  widget.onCreditToggleChanged(value);
                  HapticFeedback.selectionClick();
                  if (!value) {
                    _nameController.clear();
                    widget.onDebtorCreditorNameChanged('');
                  }
                },
                activeColor: AppTheme.getWarningColor(
                    theme.brightness == Brightness.light),
                inactiveThumbColor: colorScheme.outline,
                inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ],
          ),
          if (widget.isCreditTransaction) ...[
            SizedBox(height: 2.h),
            Text(
              _nameFieldLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _nameController,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: _nameFieldHint,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person_outline',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getWarningColor(
                        theme.brightness == Brightness.light),
                    width: 2,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
              onChanged: (value) {
                widget.onDebtorCreditorNameChanged(value);
                setState(() {});
              },
            ),
            if (_showSuggestions && _filteredSuggestions.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 20.h),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  itemCount: _filteredSuggestions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = _filteredSuggestions[index];
                    return ListTile(
                      dense: true,
                      leading: CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      title: Text(
                        suggestion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      onTap: () {
                        _nameController.text = suggestion;
                        widget.onDebtorCreditorNameChanged(suggestion);
                        _focusNode.unfocus();
                        HapticFeedback.selectionClick();
                      },
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(
                        theme.brightness == Brightness.light)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.getWarningColor(
                          theme.brightness == Brightness.light)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.getWarningColor(
                        theme.brightness == Brightness.light),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      widget.isIncomeType
                          ? 'This amount will be tracked as money to be received'
                          : 'This amount will be tracked as money to be paid',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light),
                        fontSize: 11.sp,
                      ),
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
}
