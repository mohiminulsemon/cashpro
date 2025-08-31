import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TransactionSearchBar extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onVoiceSearch;

  const TransactionSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    this.onVoiceSearch,
  });

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.onVoiceSearch != null)
                      IconButton(
                        onPressed: widget.onVoiceSearch,
                        icon: CustomIconWidget(
                          iconName: 'mic',
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: 'Voice search',
                      ),
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                        _focusNode.unfocus();
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      tooltip: 'Clear search',
                    ),
                  ],
                )
              : widget.onVoiceSearch != null
                  ? IconButton(
                      onPressed: widget.onVoiceSearch,
                      icon: CustomIconWidget(
                        iconName: 'mic',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      tooltip: 'Voice search',
                    )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
