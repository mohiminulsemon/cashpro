import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsPrivacyWidget extends StatelessWidget {
  final bool acceptedTerms;
  final bool acceptedPrivacy;
  final Function(bool) onTermsChanged;
  final Function(bool) onPrivacyChanged;

  const TermsPrivacyWidget({
    super.key,
    required this.acceptedTerms,
    required this.acceptedPrivacy,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legal Agreements',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        // Terms of Service
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptedTerms,
              onChanged: (value) => onTermsChanged(value ?? false),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTermsChanged(!acceptedTerms),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        // In a real app, this would open the terms modal/page
                        // recognizer: TapGestureRecognizer()..onTap = () => _showTerms(context),
                      ),
                      const TextSpan(text: ' *'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Privacy Policy
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptedPrivacy,
              onChanged: (value) => onPrivacyChanged(value ?? false),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onPrivacyChanged(!acceptedPrivacy),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I acknowledge the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        // In a real app, this would open the privacy modal/page
                        // recognizer: TapGestureRecognizer()..onTap = () => _showPrivacy(context),
                      ),
                      const TextSpan(text: ' and consent to data processing *'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Quick preview buttons
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _showTermsModal(context),
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('View Terms'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextButton.icon(
                onPressed: () => _showPrivacyModal(context),
                icon: const Icon(Icons.privacy_tip_outlined, size: 16),
                label: const Text('View Privacy'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTermsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terms of Service Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              _buildTermsSection(
                context,
                '1. Service Usage',
                'CashBook provides personal and business financial management tools. You agree to use the service responsibly and in compliance with applicable laws.',
              ),
              _buildTermsSection(
                context,
                '2. Data Security',
                'We implement industry-standard security measures to protect your financial data. Your information is encrypted and stored securely.',
              ),
              _buildTermsSection(
                context,
                '3. Account Responsibility',
                'You are responsible for maintaining the confidentiality of your account credentials and all activities under your account.',
              ),
              _buildTermsSection(
                context,
                '4. Service Availability',
                'We strive for 99.9% uptime but cannot guarantee uninterrupted service. Scheduled maintenance will be announced in advance.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Policy Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              _buildTermsSection(
                context,
                '1. Data Collection',
                'We collect only the financial data you provide to deliver our services. This includes transactions, categories, and account information.',
              ),
              _buildTermsSection(
                context,
                '2. Data Usage',
                'Your data is used solely to provide financial management services. We do not sell or share your personal financial information with third parties.',
              ),
              _buildTermsSection(
                context,
                '3. Data Storage',
                'All data is encrypted and stored on secure servers. We maintain regular backups to prevent data loss.',
              ),
              _buildTermsSection(
                context,
                '4. Your Rights',
                'You can export, modify, or delete your data at any time. Contact support for assistance with data requests.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(
      BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
