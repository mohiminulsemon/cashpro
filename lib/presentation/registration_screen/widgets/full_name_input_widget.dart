import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class FullNameInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const FullNameInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<FullNameInputWidget> createState() => _FullNameInputWidgetState();
}

class _FullNameInputWidgetState extends State<FullNameInputWidget> {
  bool _isValid = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateName);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateName);
    super.dispose();
  }

  void _validateName() {
    final text = widget.controller.text;
    setState(() {
      if (text.isEmpty) {
        _isValid = false;
        _errorText = null;
      } else if (text.length < 2) {
        _isValid = false;
        _errorText = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
        _isValid = false;
        _errorText = 'Name can only contain letters and spaces';
      } else if (text.split(' ').length < 2) {
        _isValid = false;
        _errorText = 'Please enter your full name (first and last)';
      } else {
        _isValid = true;
        _errorText = null;
      }
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name *',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(
              Icons.person_outline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? Icon(
                    _isValid ? Icons.check_circle : Icons.error,
                    color: _isValid
                        ? AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        : AppTheme.getErrorColor(
                            theme.brightness == Brightness.light),
                  )
                : null,
            errorText: _errorText,
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Full name is required';
            if (!_isValid) return _errorText;
            return null;
          },
        ),
        if (_isValid && widget.controller.text.isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                size: 16,
                color: AppTheme.getSuccessColor(
                    theme.brightness == Brightness.light),
              ),
              SizedBox(width: 1.w),
              Text(
                'Name looks good!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
