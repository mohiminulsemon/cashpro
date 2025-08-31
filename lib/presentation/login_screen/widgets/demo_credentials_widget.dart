import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DemoCredentialsWidget extends StatelessWidget {
  final Function(String email, String password) onDemoLogin;
  final VoidCallback onClose;

  const DemoCredentialsWidget({
    super.key,
    required this.onDemoLogin,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.successLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Mode',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    Text(
                      'Try the app with sample data',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: AppTheme.textSecondaryLight,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Demo accounts
          Text(
            'Quick Login Options:',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          SizedBox(height: 1.h),

          // Demo account buttons
          _buildDemoAccount(
            icon: Icons.person_outline,
            title: 'Personal User',
            email: 'demo@cashbook.com',
            password: 'demo123',
            description: 'Individual expense tracking',
            color: AppTheme.primaryLight,
          ),

          SizedBox(height: 1.h),

          _buildDemoAccount(
            icon: Icons.business_outlined,
            title: 'Business User',
            email: 'business@cashbook.com',
            password: 'business123',
            description: 'Business financial management',
            color: AppTheme.successLight,
          ),

          SizedBox(height: 1.h),

          _buildDemoAccount(
            icon: Icons.family_restroom_outlined,
            title: 'Family Account',
            email: 'family@cashbook.com',
            password: 'family123',
            description: 'Shared family expenses',
            color: AppTheme.warningLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDemoAccount({
    required IconData icon,
    required String title,
    required String email,
    required String password,
    required String description,
    required Color color,
  }) {
    return InkWell(
      onTap: () => onDemoLogin(email, password),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondaryLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryLight.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
