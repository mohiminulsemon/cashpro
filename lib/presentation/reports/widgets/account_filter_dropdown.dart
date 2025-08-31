import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountFilterDropdown extends StatelessWidget {
  final String selectedAccount;
  final List<Map<String, dynamic>> accounts;
  final ValueChanged<String> onAccountChanged;

  const AccountFilterDropdown({
    super.key,
    required this.selectedAccount,
    required this.accounts,
    required this.onAccountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedAccount,
          isExpanded: true,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onAccountChanged(newValue);
            }
          },
          items: accounts.map<DropdownMenuItem<String>>((account) {
            return DropdownMenuItem<String>(
              value: account['id'] as String,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(account['color'] as int),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          account['name'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          account['type'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(account['balance'] as double).toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: (account['balance'] as double) >= 0
                          ? AppTheme.getSuccessColor(
                              theme.brightness == Brightness.light)
                          : AppTheme.getErrorColor(
                              theme.brightness == Brightness.light),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
