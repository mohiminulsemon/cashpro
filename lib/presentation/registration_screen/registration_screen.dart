import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/account_type_selector_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/full_name_input_widget.dart';
import './widgets/password_input_widget.dart';
import './widgets/phone_input_widget.dart';
import './widgets/profile_photo_widget.dart';
import './widgets/terms_privacy_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Form state
  String _selectedAccountType = 'Personal';
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  String? _profilePhotoUrl;
  String _selectedCountryCode = '+1';
  bool _isLoading = false;

  // Validation state
  bool _emailAvailable = true;
  bool _passwordValid = false;
  bool _confirmPasswordValid = false;
  Map<String, bool> _passwordRequirements = {
    'length': false,
    'special': false,
    'number': false,
    'uppercase': false,
  };

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Create Account',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(),
                SizedBox(height: 4.h),

                // Profile Photo Upload
                ProfilePhotoWidget(
                  photoUrl: _profilePhotoUrl,
                  onPhotoSelected: (url) =>
                      setState(() => _profilePhotoUrl = url),
                ),
                SizedBox(height: 3.h),

                // Full Name Input
                FullNameInputWidget(
                  controller: _fullNameController,
                  onChanged: _validateForm,
                ),
                SizedBox(height: 2.h),

                // Email Input
                EmailInputWidget(
                  controller: _emailController,
                  isAvailable: _emailAvailable,
                  onChanged: _validateEmail,
                ),
                SizedBox(height: 2.h),

                // Password Input
                PasswordInputWidget(
                  controller: _passwordController,
                  requirements: _passwordRequirements,
                  onChanged: _validatePassword,
                ),
                SizedBox(height: 2.h),

                // Confirm Password Input
                _buildConfirmPasswordInput(),
                SizedBox(height: 2.h),

                // Phone Input
                PhoneInputWidget(
                  controller: _phoneController,
                  selectedCountryCode: _selectedCountryCode,
                  onCountryCodeChanged: (code) =>
                      setState(() => _selectedCountryCode = code),
                  onChanged: _validateForm,
                ),
                SizedBox(height: 3.h),

                // Account Type Selector
                AccountTypeSelectorWidget(
                  selectedType: _selectedAccountType,
                  onTypeChanged: (type) =>
                      setState(() => _selectedAccountType = type),
                ),
                SizedBox(height: 3.h),

                // Terms and Privacy
                TermsPrivacyWidget(
                  acceptedTerms: _acceptedTerms,
                  acceptedPrivacy: _acceptedPrivacy,
                  onTermsChanged: (value) =>
                      setState(() => _acceptedTerms = value),
                  onPrivacyChanged: (value) =>
                      setState(() => _acceptedPrivacy = value),
                ),
                SizedBox(height: 4.h),

                // Registration Buttons
                _buildRegistrationButtons(),
                SizedBox(height: 3.h),

                // Social Registration
                _buildSocialRegistration(),
                SizedBox(height: 2.h),

                // Demo Data Button
                _buildDemoDataButton(),
                SizedBox(height: 4.h),

                // Login Link
                _buildLoginLink(),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join CashBook',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Create your account to start managing your finances with powerful tools and insights.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordInput() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          onChanged: _validateConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: _confirmPasswordValid
                ? Icon(Icons.check_circle,
                    color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light))
                : (_confirmPasswordController.text.isNotEmpty
                    ? Icon(Icons.error,
                        color: AppTheme.getErrorColor(
                            theme.brightness == Brightness.light))
                    : null),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please confirm your password';
            if (value != _passwordController.text)
              return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegistrationButtons() {
    final theme = Theme.of(context);
    final isFormValid = _isFormValid();

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: isFormValid && !_isLoading ? _handleRegistration : null,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Create Account',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (!isFormValid) ...[
          SizedBox(height: 1.h),
          Text(
            'Please complete all required fields',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  AppTheme.getErrorColor(theme.brightness == Brightness.light),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSocialRegistration() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outline)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'or continue with',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outline)),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _handleGoogleSignUp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomIconWidget(iconName: 'google', size: 20),
                SizedBox(width: 3.w),
                Text(
                  'Sign up with Google',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoDataButton() {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: TextButton(
        onPressed: _isLoading ? null : _populateDemoData,
        child: Text(
          '🎭 Fill with Demo Data',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    final theme = Theme.of(context);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/login-screen'),
            child: Text(
              'Sign In',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateForm() {
    // Trigger form validation
  }

  void _validateEmail(String value) {
    // Simulate email availability check
    setState(() {
      _emailAvailable = !value.contains('taken@');
    });
    _validateForm();
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordRequirements = {
        'length': value.length >= 8,
        'special': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value),
        'number': RegExp(r'[0-9]').hasMatch(value),
        'uppercase': RegExp(r'[A-Z]').hasMatch(value),
      };
      _passwordValid = _passwordRequirements.values.every((req) => req);
    });
    _validateConfirmPassword(_confirmPasswordController.text);
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _confirmPasswordValid =
          value.isNotEmpty && value == _passwordController.text;
    });
  }

  bool _isFormValid() {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _emailAvailable &&
        _passwordValid &&
        _confirmPasswordValid &&
        _phoneController.text.isNotEmpty &&
        _acceptedTerms &&
        _acceptedPrivacy;
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account created successfully!'),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );

        // Navigate to onboarding
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: AppTheme.getErrorColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    try {
      // Simulate Google Sign-Up
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-Up successful!')),
        );
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-Up failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _populateDemoData() {
    setState(() {
      _fullNameController.text = 'John Smith';
      _emailController.text = 'john.smith@example.com';
      _passwordController.text = 'SecurePass123!';
      _confirmPasswordController.text = 'SecurePass123!';
      _phoneController.text = '(555) 123-4567';
      _selectedAccountType = 'Personal';
      _selectedCountryCode = '+1';
      _acceptedTerms = true;
      _acceptedPrivacy = true;
      _profilePhotoUrl =
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face';
    });

    // Validate the demo data
    _validatePassword(_passwordController.text);
    _validateEmail(_emailController.text);
    _validateForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo data populated! Ready to create account.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}