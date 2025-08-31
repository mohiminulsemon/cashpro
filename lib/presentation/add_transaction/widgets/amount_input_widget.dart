import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AmountInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onAmountChanged;
  final String currency;

  const AmountInputWidget({
    super.key,
    required this.controller,
    required this.onAmountChanged,
    this.currency = '\$',
  });

  @override
  State<AmountInputWidget> createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<AmountInputWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String _formatAmount(String value) {
    if (value.isEmpty) return '';

    // Remove any non-digit characters except decimal point
    String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle multiple decimal points
    List<String> parts = cleanValue.split('.');
    if (parts.length > 2) {
      cleanValue = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit decimal places to 2
    if (parts.length == 2 && parts[1].length > 2) {
      cleanValue = '${parts[0]}.${parts[1].substring(0, 2)}';
    }

    return cleanValue;
  }

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
          Text(
            'Amount',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.currency,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    final formattedValue = _formatAmount(value);
                    if (formattedValue != value) {
                      widget.controller.value = TextEditingValue(
                        text: formattedValue,
                        selection: TextSelection.collapsed(
                            offset: formattedValue.length),
                      );
                    }
                    widget.onAmountChanged(formattedValue);
                  },
                  onTap: () {
                    if (widget.controller.text.isEmpty) {
                      widget.controller.text = '';
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildQuickAmountButton('10', context),
              SizedBox(width: 2.w),
              _buildQuickAmountButton('50', context),
              SizedBox(width: 2.w),
              _buildQuickAmountButton('100', context),
              SizedBox(width: 2.w),
              _buildQuickAmountButton('500', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountButton(String amount, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () {
          widget.controller.text = amount;
          widget.onAmountChanged(amount);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            '${widget.currency}$amount',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
