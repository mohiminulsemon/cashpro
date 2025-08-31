import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing Contemporary Financial Clarity design
/// Provides consistent navigation and branding across the application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show elevation shadow
  final bool showElevation;

  /// Custom background color (uses theme default if null)
  final Color? backgroundColor;

  /// Custom text color (uses theme default if null)
  final Color? foregroundColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (like tabs)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.showElevation = false,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
          letterSpacing: -0.02,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: showElevation ? 2 : 0,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      leading: leading ??
          (canPop && showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      bottom: bottom,
      automaticallyImplyLeading: false,
    );
  }

  /// Builds a custom back button with proper styling
  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: colorScheme.onSurface,
        size: 20,
      ),
      tooltip: 'Back',
      splashRadius: 24,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  /// Factory constructor for dashboard app bar with specific styling
  factory CustomAppBar.dashboard({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Dashboard',
      showBackButton: false,
      centerTitle: false,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/profile-settings'),
                icon: const Icon(Icons.account_circle_outlined),
                tooltip: 'Profile',
              ),
            ),
          ],
    );
  }

  /// Factory constructor for transaction-related screens
  factory CustomAppBar.transaction({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: true,
      actions: actions,
    );
  }

  /// Factory constructor for reports screen with export actions
  factory CustomAppBar.reports({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Reports',
      showBackButton: true,
      actions: actions ??
          [
            Builder(
              builder: (context) => PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle export actions
                  switch (value) {
                    case 'export_pdf':
                      // Handle PDF export
                      break;
                    case 'export_csv':
                      // Handle CSV export
                      break;
                    case 'share':
                      // Handle sharing
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'export_pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined),
                        SizedBox(width: 12),
                        Text('Export PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'export_csv',
                    child: Row(
                      children: [
                        Icon(Icons.table_chart_outlined),
                        SizedBox(width: 12),
                        Text('Export CSV'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined),
                        SizedBox(width: 12),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
                tooltip: 'More options',
              ),
            ),
          ],
    );
  }

  /// Factory constructor for settings screen
  factory CustomAppBar.settings({
    Key? key,
    String title = 'Settings',
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      showBackButton: true,
    );
  }

  /// Factory constructor for receipt viewer with specific actions
  factory CustomAppBar.receiptViewer({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Receipt',
      showBackButton: true,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  // Handle receipt sharing
                },
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share receipt',
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  // Handle receipt download
                },
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Download receipt',
              ),
            ),
          ],
    );
  }
}
