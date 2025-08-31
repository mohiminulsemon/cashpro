import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data structure for bottom navigation
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// Custom bottom navigation bar implementing Contemporary Financial Clarity design
/// Provides main navigation structure for the financial application
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Whether to show labels
  final bool showLabels;

  /// Navigation items (uses default financial app items if null)
  final List<BottomNavItem>? items;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.showLabels = true,
    this.items,
  });

  /// Default navigation items for financial application
  static const List<BottomNavItem> _defaultItems = [
    BottomNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    BottomNavItem(
      label: 'Add',
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      route: '/add-transaction',
    ),
    BottomNavItem(
      label: 'History',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      route: '/transaction-history',
    ),
    BottomNavItem(
      label: 'Reports',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      route: '/reports',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navigationItems = items ?? _defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item with proper styling and animations
  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () => _handleNavigation(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  key: ValueKey(isSelected),
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: 0.4,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handles navigation when item is tapped
  void _handleNavigation(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      // Use pushNamedAndRemoveUntil to replace the current route stack
      // This ensures proper navigation behavior for bottom navigation
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }

  /// Factory constructor for main app navigation
  factory CustomBottomBar.main({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      showLabels: true,
    );
  }

  /// Factory constructor for compact navigation (icons only)
  factory CustomBottomBar.compact({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      showLabels: false,
    );
  }

  /// Helper method to get current index based on route name
  static int getIndexFromRoute(String? routeName) {
    switch (routeName) {
      case '/dashboard':
        return 0;
      case '/add-transaction':
        return 1;
      case '/transaction-history':
        return 2;
      case '/reports':
        return 3;
      default:
        return 0;
    }
  }

  /// Helper method to determine if bottom bar should be shown for a route
  static bool shouldShowForRoute(String? routeName) {
    const mainRoutes = [
      '/dashboard',
      '/add-transaction',
      '/transaction-history',
      '/reports',
    ];
    return mainRoutes.contains(routeName);
  }
}
