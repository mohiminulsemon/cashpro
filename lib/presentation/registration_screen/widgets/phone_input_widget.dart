import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PhoneInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;
  final VoidCallback? onChanged;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    this.onChanged,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  bool _isValid = false;
  String? _errorText;

  final List<Map<String, String>> _countries = [
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽'},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePhone);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePhone);
    super.dispose();
  }

  void _validatePhone() {
    final text = widget.controller.text;

    if (text.isEmpty) {
      setState(() {
        _isValid = false;
        _errorText = null;
      });
      widget.onChanged?.call();
      return;
    }

    // Remove any formatting characters for validation
    final cleanedText = text.replaceAll(RegExp(r'[^\d]'), '');

    // Validate based on country code
    bool isValidLength = false;
    switch (widget.selectedCountryCode) {
      case '+1': // US/Canada
        isValidLength = cleanedText.length == 10;
        break;
      case '+44': // UK
        isValidLength = cleanedText.length == 10;
        break;
      case '+91': // India
        isValidLength = cleanedText.length == 10;
        break;
      default:
        isValidLength = cleanedText.length >= 8 && cleanedText.length <= 15;
    }

    setState(() {
      if (!isValidLength) {
        _isValid = false;
        _errorText = 'Invalid phone number format';
      } else {
        _isValid = true;
        _errorText = null;
      }
    });
    widget.onChanged?.call();
  }

  String _formatPhoneNumber(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^\d]'), '');

    // Format based on country code
    if (widget.selectedCountryCode == '+1' && cleaned.length <= 10) {
      // US/Canada format: (123) 456-7890
      if (cleaned.length >= 6) {
        return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
      } else if (cleaned.length >= 3) {
        return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3)}';
      } else {
        return cleaned;
      }
    }

    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedCountry = _countries.firstWhere(
      (country) => country['code'] == widget.selectedCountryCode,
      orElse: () => _countries.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number *',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Country code selector
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCountry['flag'] ?? '🇺🇸',
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.selectedCountryCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Phone number input
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
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
                onChanged: (value) {
                  // Format the input as user types
                  final formatted = _formatPhoneNumber(value);
                  if (formatted != value) {
                    widget.controller.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Phone number is required';
                  if (!_isValid) return _errorText;
                  return null;
                },
              ),
            ),
          ],
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
                'Phone number format is valid',
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

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Text(
              'Select Country',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected =
                      country['code'] == widget.selectedCountryCode;

                  return ListTile(
                    leading: Text(
                      country['flag'] ?? '🌍',
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(country['name'] ?? ''),
                    subtitle: Text(country['code'] ?? ''),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      widget.onCountryCodeChanged(country['code'] ?? '+1');
                      Navigator.pop(context);
                      _validatePhone();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
