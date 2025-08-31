import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Welcome to CashBook',
      subtitle: 'Your Personal Finance Command Center',
      description:
          'Take control of your financial future with powerful tools designed to help you track, analyze, and optimize your money management journey.',
      imageUrl:
          'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
      backgroundColor: const Color(0xFF2563EB),
      features: [
        'Smart expense tracking',
        'Real-time insights',
        'Secure data protection',
      ],
    ),
    OnboardingData(
      title: 'Smart Transaction Entry',
      subtitle: 'Effortless Money Tracking',
      description:
          'Add transactions in seconds with our intuitive interface. Categorize expenses, attach receipts, and never miss a financial detail.',
      imageUrl:
          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=300&fit=crop',
      backgroundColor: const Color(0xFF059669),
      demoTransaction: {
        'amount': 45.50,
        'category': 'Food & Dining',
        'description': 'Lunch at downtown cafe',
        'type': 'expense',
        'hasReceipt': true,
      },
      features: [
        'Quick categorization',
        'Receipt attachment',
        'Income & expense tracking',
      ],
    ),
    OnboardingData(
      title: 'Powerful Insights',
      subtitle: 'Understand Your Money',
      description:
          'Get detailed reports and visual charts that reveal your spending patterns, help identify savings opportunities, and guide better financial decisions.',
      imageUrl:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop',
      backgroundColor: const Color(0xFF7C3AED),
      demoCharts: {
        'monthlyExpenses': [1200, 1350, 980, 1500, 1100],
        'categoryBreakdown': {
          'Food': 35,
          'Transport': 20,
          'Shopping': 25,
          'Bills': 15,
          'Other': 5,
        },
      },
      features: [
        'Visual spending charts',
        'Monthly comparisons',
        'Category breakdowns',
      ],
    ),
    OnboardingData(
      title: 'Stay Informed',
      subtitle: 'Smart Notifications & Backup',
      description:
          'Receive intelligent alerts about your spending patterns, budget limits, and important financial milestones. Your data is always backed up and secure.',
      imageUrl:
          'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=400&h=300&fit=crop',
      backgroundColor: const Color(0xFFDC2626),
      features: [
        'Smart spending alerts',
        'Automatic cloud backup',
        'Privacy-first design',
      ],
    ),
    OnboardingData(
      title: 'Start Your Journey',
      subtitle: 'Choose Your Adventure',
      description:
          'Ready to take control? Choose how you\'d like to begin your financial journey with CashBook.',
      imageUrl:
          'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=400&h=300&fit=crop',
      backgroundColor: const Color(0xFF0891B2),
      isSetupPage: true,
      features: [
        'Import existing data',
        'Start fresh',
        'Explore with demo data',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _onboardingData[_currentPage].backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            _buildTopNavigation(),

            // Main Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),

            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicator
          Row(
            children: List.generate(
              _onboardingData.length,
              (index) => _buildPageIndicator(index),
            ),
          ),

          // Skip Button
          if (!_isLastPage)
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 1.w),
      width: isActive ? 8.w : 2.w,
      height: 1.h,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    if (data.isSetupPage) {
      return _buildSetupPage(data);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),

          // Illustration
          Container(
            width: 80.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: data.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Content
          Text(
            data.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            data.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Demo Content
          if (data.demoTransaction != null)
            _buildDemoTransaction(data.demoTransaction!),
          if (data.demoCharts != null) _buildDemoCharts(data.demoCharts!),

          SizedBox(height: 3.h),

          // Features List
          _buildFeaturesList(data.features),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildDemoTransaction(Map<String, dynamic> transaction) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: transaction['type'] == 'expense'
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: transaction['type'] == 'expense'
                  ? 'trending_down'
                  : 'trending_up',
              color:
                  transaction['type'] == 'expense' ? Colors.red : Colors.green,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      transaction['category'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                    if (transaction['hasReceipt'] == true) ...[
                      SizedBox(width: 2.w),
                      const CustomIconWidget(
                        iconName: 'receipt',
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '\$${transaction['amount'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color:
                  transaction['type'] == 'expense' ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCharts(Map<String, dynamic> chartData) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Spending Overview',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),

          // Simple bar chart representation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final values = chartData['monthlyExpenses'] as List<num>;
              final maxValue = values.reduce((a, b) => a > b ? a : b);
              final height = (values[index] / maxValue) * 15.h;

              return Column(
                children: [
                  Container(
                    width: 8.w,
                    height: height,
                    decoration: BoxDecoration(
                      color: _onboardingData[_currentPage]
                          .backgroundColor
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'M${index + 1}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(List<String> features) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: features
            .map((feature) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      const CustomIconWidget(
                        iconName: 'check_circle',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSetupPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 60.w,
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: data.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            data.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            data.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Setup Options
          _buildSetupOption(
            'Import Existing Data',
            'Connect your bank account or import CSV files',
            Icons.upload_file,
            () => _handleSetupChoice('import'),
          ),

          SizedBox(height: 2.h),

          _buildSetupOption(
            'Start Fresh',
            'Begin with a clean slate and add transactions manually',
            Icons.add_circle_outline,
            () => _handleSetupChoice('fresh'),
          ),

          SizedBox(height: 2.h),

          _buildSetupOption(
            'Explore Demo Data',
            'Try CashBook with sample transactions and data',
            Icons.explore,
            () => _handleSetupChoice('demo'),
            isPrimary: true,
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSetupOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isPrimary
                    ? _onboardingData[_currentPage]
                        .backgroundColor
                        .withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPrimary
                    ? _onboardingData[_currentPage].backgroundColor
                    : Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.black87 : Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isPrimary
                          ? Colors.black54
                          : Colors.white.withValues(alpha: 0.8),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isPrimary
                  ? Colors.black54
                  : Colors.white.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          if (_currentPage > 0)
            TextButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 16),
              label: Text(
                'Previous',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          // Next/Get Started Button
          if (!_isLastPage)
            ElevatedButton.icon(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _onboardingData[_currentPage].backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              label: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _isLastPage = index == _onboardingData.length - 1;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _handleSetupChoice(String choice) {
    switch (choice) {
      case 'import':
        _showComingSoon('Import feature');
        break;
      case 'fresh':
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 'demo':
        _startWithDemoData();
        break;
    }
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text(
            '$feature will be available in a future update. For now, let\'s start with demo data!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startWithDemoData();
            },
            child: const Text('Continue with Demo'),
          ),
        ],
      ),
    );
  }

  void _startWithDemoData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Welcome to CashBook! Demo data has been loaded.'),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pushReplacementNamed(context, '/dashboard');
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final Color backgroundColor;
  final List<String> features;
  final Map<String, dynamic>? demoTransaction;
  final Map<String, dynamic>? demoCharts;
  final bool isSetupPage;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    required this.features,
    this.demoTransaction,
    this.demoCharts,
    this.isSetupPage = false,
  });
}
