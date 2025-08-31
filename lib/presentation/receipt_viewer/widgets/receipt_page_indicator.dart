import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Page indicator for multiple receipt images
class ReceiptPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  const ReceiptPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (totalPages <= 1) return const SizedBox.shrink();

    return Positioned(
      top: 12.h,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous button
              if (currentPage > 0)
                GestureDetector(
                  onTap: () => onPageChanged?.call(currentPage - 1),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'chevron_left',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

              SizedBox(width: 2.w),

              // Page indicators
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  totalPages,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: index == currentPage ? 3.w : 2.w,
                    height: index == currentPage ? 3.w : 2.w,
                    decoration: BoxDecoration(
                      color: index == currentPage
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(1.5.w),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Next button
              if (currentPage < totalPages - 1)
                GestureDetector(
                  onTap: () => onPageChanged?.call(currentPage + 1),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
