import 'package:flutter/material.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/add_transaction/add_transaction.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/receipt_viewer/receipt_viewer.dart';
import '../presentation/reports/reports.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';

class AppRoutes {
  static const String initial = '/splash-screen';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String registrationScreen = '/registration-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String dashboard = '/dashboard';
  static const String transactionHistory = '/transaction-history';
  static const String addTransaction = '/add-transaction';
  static const String profileSettings = '/profile-settings';
  static const String receiptViewer = '/receipt-viewer';
  static const String reports = '/reports';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    dashboard: (context) => const Dashboard(),
    transactionHistory: (context) => const TransactionHistory(),
    addTransaction: (context) => const AddTransaction(),
    profileSettings: (context) => const ProfileSettings(),
    receiptViewer: (context) => const ReceiptViewer(),
    reports: (context) => const Reports(),
  };
}
