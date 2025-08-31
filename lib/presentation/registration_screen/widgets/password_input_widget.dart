import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class PasswordInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Map<String, bool> requirements;
  final Function(String) onChanged;

  const PasswordInputWidget({
    super.key,
    required this.controller,
    required this.requirements,
    required this.onChanged,
  });

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool _obscurePassword = true;
  bool _showRequirements = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handlePasswordChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handlePasswordChange);
    super.dispose();
  }

  void _handlePasswordChange() {
    final text = widget.controller.text;
    setState(() {
      _showRequirements = text.isNotEmpty;
    });
    widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final allRequirementsMet = widget.requirements.values.every((req) => req);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password *',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.controller.text.isNotEmpty)
                  Icon(
                    allRequirementsMet ? Icons.check_circle : Icons.error,
                    color: allRequirementsMet
                        ? AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        : AppTheme.getErrorColor(
                            theme.brightness == Brightness.light),
                  ),
                IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Password is required';
            if (!allRequirementsMet)
              return 'Password does not meet requirements';
            return null;
          },
        ),

        // Password Requirements Checklist
        if (_showRequirements) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Requirements',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildRequirement(
                  'At least 8 characters',
                  widget.requirements['length'] ?? false,
                  theme,
                ),
                _buildRequirement(
                  'Contains uppercase letter',
                  widget.requirements['uppercase'] ?? false,
                  theme,
                ),
                _buildRequirement(
                  'Contains number',
                  widget.requirements['number'] ?? false,
                  theme,
                ),
                _buildRequirement(
                  'Contains special character',
                  widget.requirements['special'] ?? false,
                  theme,
                ),
              ],
            ),
          ),
        ],

        // Password Strength Meter
        if (widget.controller.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          _buildPasswordStrengthMeter(theme),
        ],
      ],
    );
  }

  Widget _buildRequirement(String text, bool met, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: met
                ? AppTheme.getSuccessColor(theme.brightness == Brightness.light)
                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: met
                  ? AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: met ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthMeter(ThemeData theme) {
    final metCount = widget.requirements.values.where((req) => req).length;
    final strength = metCount / widget.requirements.length;

    Color strengthColor;
    String strengthText;

    if (strength <= 0.25) {
      strengthColor =
          AppTheme.getErrorColor(theme.brightness == Brightness.light);
      strengthText = 'Weak';
    } else if (strength <= 0.5) {
      strengthColor =
          AppTheme.getWarningColor(theme.brightness == Brightness.light);
      strengthText = 'Fair';
    } else if (strength <= 0.75) {
      strengthColor =
          AppTheme.getWarningColor(theme.brightness == Brightness.light);
      strengthText = 'Good';
    } else {
      strengthColor =
          AppTheme.getSuccessColor(theme.brightness == Brightness.light);
      strengthText = 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              strengthText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: strength,
          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          minHeight: 4,
        ),
      ],
    );
  }
}
