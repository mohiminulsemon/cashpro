import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_info_widget.dart';
import './widgets/data_usage_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_group_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_switch_widget.dart';

/// Profile Settings screen for managing user preferences and account configuration
class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "John Anderson",
    "email": "john.anderson@gmail.com",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "accountType": "Business",
    "joinDate": "January 2024",
  };

  // Settings state
  bool _biometricEnabled = true;
  bool _transactionReminders = true;
  bool _backupNotifications = false;
  bool _reportGeneration = true;
  bool _darkModeEnabled = false;
  String _selectedCurrency = "USD (\$)";
  String _selectedDateFormat = "MM/DD/YYYY";
  int _autoLockTimer = 5; // minutes

  // Mock data usage
  final Map<String, dynamic> _dataUsage = {
    "storageUsed": "2.4 GB",
    "totalStorage": "5.0 GB",
    "usagePercentage": 48.0,
    "lastBackup": "Today at 3:45 PM",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 5.w,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userName: _userData["name"] as String,
                userEmail: _userData["email"] as String,
                profileImageUrl: _userData["profileImage"] as String,
                accountType: _userData["accountType"] as String,
                onProfileTap: _handleProfileEdit,
              ),
              SizedBox(height: 3.h),

              // Security Settings
              SettingsGroupWidget(
                title: 'Security',
                children: [
                  SettingsSwitchWidget(
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face unlock',
                    iconName: 'fingerprint',
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() => _biometricEnabled = value);
                      _handleBiometricToggle(value);
                    },
                  ),
                  SettingsItemWidget(
                    title: 'Auto-Lock Timer',
                    subtitle: '$_autoLockTimer minutes',
                    iconName: 'lock_clock',
                    onTap: _showAutoLockDialog,
                  ),
                  SettingsItemWidget(
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    iconName: 'lock_reset',
                    onTap: _handlePasswordChange,
                  ),
                ],
              ),

              // Notification Settings
              SettingsGroupWidget(
                title: 'Notifications',
                children: [
                  SettingsSwitchWidget(
                    title: 'Transaction Reminders',
                    subtitle: 'Daily expense tracking reminders',
                    iconName: 'notifications',
                    value: _transactionReminders,
                    onChanged: (value) {
                      setState(() => _transactionReminders = value);
                      _handleNotificationToggle('reminders', value);
                    },
                  ),
                  SettingsSwitchWidget(
                    title: 'Backup Status',
                    subtitle: 'Notifications about data backup',
                    iconName: 'cloud_sync',
                    value: _backupNotifications,
                    onChanged: (value) {
                      setState(() => _backupNotifications = value);
                      _handleNotificationToggle('backup', value);
                    },
                  ),
                  SettingsSwitchWidget(
                    title: 'Report Generation',
                    subtitle: 'Alerts when reports are ready',
                    iconName: 'assessment',
                    value: _reportGeneration,
                    onChanged: (value) {
                      setState(() => _reportGeneration = value);
                      _handleNotificationToggle('reports', value);
                    },
                  ),
                ],
              ),

              // Data Management
              SettingsGroupWidget(
                title: 'Data Management',
                children: [
                  DataUsageWidget(
                    storageUsed: _dataUsage["storageUsed"] as String,
                    totalStorage: _dataUsage["totalStorage"] as String,
                    usagePercentage: _dataUsage["usagePercentage"] as double,
                    lastBackupTime: _dataUsage["lastBackup"] as String,
                    onBackupTap: _handleManualBackup,
                    onExportTap: _handleDataExport,
                  ),
                ],
              ),

              // Appearance Settings
              SettingsGroupWidget(
                title: 'Appearance',
                children: [
                  SettingsSwitchWidget(
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    iconName: 'dark_mode',
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() => _darkModeEnabled = value);
                      _handleThemeToggle(value);
                    },
                  ),
                  SettingsItemWidget(
                    title: 'Currency Format',
                    subtitle: _selectedCurrency,
                    iconName: 'attach_money',
                    onTap: _showCurrencyDialog,
                  ),
                  SettingsItemWidget(
                    title: 'Date Format',
                    subtitle: _selectedDateFormat,
                    iconName: 'calendar_today',
                    onTap: _showDateFormatDialog,
                  ),
                ],
              ),

              // Account Management
              SettingsGroupWidget(
                title: 'Account',
                children: [
                  SettingsItemWidget(
                    title: 'Add Business Account',
                    subtitle: 'Manage multiple account types',
                    iconName: 'business',
                    onTap: _handleAddAccount,
                  ),
                  SettingsItemWidget(
                    title: 'Account Switching',
                    subtitle: 'Switch between personal and business',
                    iconName: 'swap_horiz',
                    onTap: _handleAccountSwitch,
                  ),
                ],
              ),

              // App Information
              AppInfoWidget(
                appVersion: '1.2.0',
                onPrivacyPolicyTap: _handlePrivacyPolicy,
                onTermsOfServiceTap: _handleTermsOfService,
                onSupportTap: _handleSupport,
                onRateAppTap: _handleRateApp,
              ),
              SizedBox(height: 3.h),

              // Logout Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: CustomIconWidget(
                    iconName: 'logout',
                    color: Colors.white,
                    size: 5.w,
                  ),
                  label: Text(
                    'Sign Out',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Actions
  void _handleProfileEdit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text(
            'Profile editing functionality will be implemented with Firebase Auth profile updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Security Actions
  void _handleBiometricToggle(bool enabled) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAutoLockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-Lock Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1, 5, 10, 15, 30].map((minutes) {
            return RadioListTile<int>(
              title: Text('$minutes minutes'),
              value: minutes,
              groupValue: _autoLockTimer,
              onChanged: (value) {
                setState(() => _autoLockTimer = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handlePasswordChange() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text(
            'Password change functionality will be implemented with Firebase Auth.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Notification Actions
  void _handleNotificationToggle(String type, bool enabled) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${type.capitalize()} notifications ${enabled ? 'enabled' : 'disabled'}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Data Management Actions
  void _handleManualBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Backup'),
        content: const Text('Starting backup to Firebase Cloud Storage...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleDataExport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: Colors.red,
                size: 6.w,
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Financial reports and summaries'),
              onTap: () {
                Navigator.pop(context);
                _exportData('PDF');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: Colors.green,
                size: 6.w,
              ),
              title: const Text('Export as Excel'),
              subtitle: const Text('Transaction data and analytics'),
              onTap: () {
                Navigator.pop(context);
                _exportData('Excel');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _exportData(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data as $format...'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Appearance Actions
  void _handleThemeToggle(bool isDark) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDark ? 'Dark mode enabled' : 'Light mode enabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCurrencyDialog() {
    final currencies = [
      'USD (\$)',
      'EUR (€)',
      'GBP (£)',
      'JPY (¥)',
      'INR (₹)',
      'CAD (C\$)',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() => _selectedCurrency = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDateFormatDialog() {
    final formats = [
      'MM/DD/YYYY',
      'DD/MM/YYYY',
      'YYYY-MM-DD',
      'DD-MM-YYYY',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            return RadioListTile<String>(
              title: Text(format),
              value: format,
              groupValue: _selectedDateFormat,
              onChanged: (value) {
                setState(() => _selectedDateFormat = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // Account Actions
  void _handleAddAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Account'),
        content: const Text(
            'Account creation functionality will be implemented with Firebase multi-account support.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleAccountSwitch() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Switch Account',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Personal Account'),
              subtitle: const Text('john.anderson@gmail.com'),
              trailing: _userData["accountType"] == "Personal"
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: Theme.of(context).colorScheme.primary,
                      size: 5.w,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                _switchAccount('Personal');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'business',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Business Account'),
              subtitle: const Text('Anderson Consulting LLC'),
              trailing: _userData["accountType"] == "Business"
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: Theme.of(context).colorScheme.primary,
                      size: 5.w,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                _switchAccount('Business');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _switchAccount(String accountType) {
    setState(() {
      _userData["accountType"] = accountType;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to $accountType account'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // App Info Actions
  void _handlePrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Privacy Policy...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Terms of Service...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Support Center...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleRateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening App Store for rating...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Logout Action
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
            'Are you sure you want to sign out? Your data will be safely stored in the cloud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Clear user session and navigate to login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signing out...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to dashboard (simulating logout flow)
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
    );
  }
}

// Extension for string capitalization
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
