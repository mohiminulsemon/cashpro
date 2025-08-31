import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class EmailInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isAvailable;
  final Function(String) onChanged;

  const EmailInputWidget({
    super.key,
    required this.controller,
    required this.isAvailable,
    required this.onChanged,
  });

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  bool _isValid = false;
  bool _isChecking = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateEmail);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateEmail);
    super.dispose();
  }

  void _validateEmail() async {
    final text = widget.controller.text;

    if (text.isEmpty) {
      setState(() {
        _isValid = false;
        _errorText = null;
        _isChecking = false;
      });
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) {
      setState(() {
        _isValid = false;
        _errorText = 'Please enter a valid email address';
        _isChecking = false;
      });
      widget.onChanged(text);
      return;
    }

    // Domain validation
    final domain = text.split('@').last.toLowerCase();
    final commonDomains = [
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com',
      'icloud.com',
      'aol.com',
      'example.com'
    ];

    if (!commonDomains.contains(domain) && !domain.contains('.')) {
      setState(() {
        _isValid = false;
        _errorText = 'Please use a valid email domain';
        _isChecking = false;
      });
      widget.onChanged(text);
      return;
    }

    setState(() => _isChecking = true);

    // Simulate availability check
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isChecking = false;
        if (!widget.isAvailable) {
          _isValid = false;
          _errorText = 'This email is already registered';
        } else {
          _isValid = true;
          _errorText = null;
        }
      });
      widget.onChanged(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address *',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: _isChecking
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (widget.controller.text.isNotEmpty
                    ? Icon(
                        _isValid ? Icons.check_circle : Icons.error,
                        color: _isValid
                            ? AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light)
                            : AppTheme.getErrorColor(
                                theme.brightness == Brightness.light),
                      )
                    : null),
            errorText: _errorText,
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Email address is required';
            if (!_isValid) return _errorText;
            return null;
          },
        ),
        if (_isValid && widget.controller.text.isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Icon(
                Icons.verified,
                size: 16,
                color: AppTheme.getSuccessColor(
                    theme.brightness == Brightness.light),
              ),
              SizedBox(width: 1.w),
              Text(
                'Email is available!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                ),
              ),
            ],
          ),
        ],
        if (!widget.isAvailable && widget.controller.text.isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppTheme.getWarningColor(
                    theme.brightness == Brightness.light),
              ),
              SizedBox(width: 1.w),
              Text(
                'Try a different email or sign in instead',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getWarningColor(
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
