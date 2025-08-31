import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data structure for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? route;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.route,
  });
}

/// Custom tab bar widget implementing Contemporary Financial Clarity design
/// Provides secondary navigation within screens (e.g., transaction types, report periods)
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// Current selected index
  final int currentIndex;

  /// Callback when tab is selected
  final ValueChanged<int>? onTap;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color for selected tab
  final Color? selectedLabelColor;

  /// Custom label color for unselected tabs
  final Color? unselectedLabelColor;

  /// Whether to show icons
  final bool showIcons;

  /// Tab alignment when not scrollable
  final TabAlignment tabAlignment;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.isScrollable = false,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.showIcons = false,
    this.tabAlignment = TabAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: _buildTabs(context),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: selectedLabelColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        labelPadding:
            isScrollable ? const EdgeInsets.symmetric(horizontal: 16) : null,
        onTap: (index) {
          onTap?.call(index);
          _handleTabNavigation(context, index);
        },
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  /// Builds the list of tab widgets
  List<Widget> _buildTabs(BuildContext context) {
    return tabs.map((tab) {
      if (showIcons && (tab.icon != null || tab.customIcon != null)) {
        return Tab(
          icon: tab.customIcon ?? Icon(tab.icon, size: 20),
          text: tab.label,
          iconMargin: const EdgeInsets.only(bottom: 4),
        );
      } else {
        return Tab(text: tab.label);
      }
    }).toList();
  }

  /// Handles navigation when tab is tapped
  void _handleTabNavigation(BuildContext context, int index) {
    final tab = tabs[index];
    if (tab.route != null) {
      Navigator.pushNamed(context, tab.route!);
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);

  /// Factory constructor for transaction type tabs (Income/Expense)
  factory CustomTabBar.transactionTypes({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        TabItem(
          label: 'Income',
          icon: Icons.trending_up,
        ),
        TabItem(
          label: 'Expense',
          icon: Icons.trending_down,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      showIcons: true,
      isScrollable: false,
    );
  }

  /// Factory constructor for report period tabs
  factory CustomTabBar.reportPeriods({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        TabItem(label: 'Week'),
        TabItem(label: 'Month'),
        TabItem(label: 'Quarter'),
        TabItem(label: 'Year'),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
    );
  }

  /// Factory constructor for transaction history filters
  factory CustomTabBar.historyFilters({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        TabItem(label: 'All'),
        TabItem(label: 'Income'),
        TabItem(label: 'Expenses'),
        TabItem(label: 'Transfers'),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
    );
  }

  /// Factory constructor for dashboard overview tabs
  factory CustomTabBar.dashboardOverview({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        TabItem(
          label: 'Overview',
          icon: Icons.dashboard_outlined,
        ),
        TabItem(
          label: 'Analytics',
          icon: Icons.analytics_outlined,
        ),
        TabItem(
          label: 'Goals',
          icon: Icons.flag_outlined,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      showIcons: true,
      isScrollable: false,
    );
  }

  /// Factory constructor for settings categories
  factory CustomTabBar.settingsCategories({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        TabItem(label: 'General'),
        TabItem(label: 'Security'),
        TabItem(label: 'Notifications'),
        TabItem(label: 'Data'),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
    );
  }

  /// Factory constructor for custom tabs with specific styling
  factory CustomTabBar.custom({
    Key? key,
    required List<TabItem> tabs,
    required int currentIndex,
    ValueChanged<int>? onTap,
    bool isScrollable = false,
    bool showIcons = false,
    Color? backgroundColor,
    Color? indicatorColor,
    Color? selectedLabelColor,
    Color? unselectedLabelColor,
  }) {
    return CustomTabBar(
      key: key,
      tabs: tabs,
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: isScrollable,
      showIcons: showIcons,
      backgroundColor: backgroundColor,
      indicatorColor: indicatorColor,
      selectedLabelColor: selectedLabelColor,
      unselectedLabelColor: unselectedLabelColor,
    );
  }
}

/// Custom tab bar view for displaying tab content
class CustomTabBarView extends StatelessWidget {
  /// List of widgets to display for each tab
  final List<Widget> children;

  /// Tab controller
  final TabController? controller;

  /// Physics for the page view
  final ScrollPhysics? physics;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics ?? const ClampingScrollPhysics(),
      children: children,
    );
  }
}
