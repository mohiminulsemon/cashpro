import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/demo_credentials_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _showDemo = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo credentials
    _emailController.text = 'demo@cashpro.com';
    _passwordController.text = 'demo123';
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Add haptic feedback
    await HapticFeedback.lightImpact();

    // Simulate authentication delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Demo authentication - always succeeds
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      _navigateToDashboard();
    }
  }

  Future<void> _handleForgotPassword() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'In the full app, this would send a reset link to your email.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleDemoLogin(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
    _handleLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.h),

                // Logo and branding
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryLight.withValues(alpha: 0.3),
                        blurRadius: 20.0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  'Welcome Back',
                  style: GoogleFonts.inter(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryLight,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'Sign in to manage your finances',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondaryLight,
                    letterSpacing: 0.2,
                  ),
                ),

                SizedBox(height: 4.h),

                // Demo credentials banner
                if (_showDemo)
                  DemoCredentialsWidget(
                    onDemoLogin: _handleDemoLogin,
                    onClose: () => setState(() => _showDemo = false),
                  ),

                SizedBox(height: _showDemo ? 3.h : 0),

                // Login form
                LoginFormWidget(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  rememberMe: _rememberMe,
                  isLoading: _isLoading,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onRememberMeChanged: (value) =>
                      setState(() => _rememberMe = value),
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),

                SizedBox(height: 3.h),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'or continue with',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: 3.h),

                // Social login
                SocialLoginWidget(
                  isLoading: _isLoading,
                  onSocialLogin: _handleSocialLogin,
                ),

                SizedBox(height: 4.h),

                // Registration link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // In demo mode, just show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Registration feature coming soon!',
                              style: GoogleFonts.inter(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
