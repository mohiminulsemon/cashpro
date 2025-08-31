import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

/// Widget for displaying receipt image with zoom and pan capabilities
class ReceiptImageViewer extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onImageTap;
  final bool isLoading;

  const ReceiptImageViewer({
    super.key,
    required this.imageUrl,
    this.onImageTap,
    this.isLoading = false,
  });

  @override
  State<ReceiptImageViewer> createState() => _ReceiptImageViewerState();
}

class _ReceiptImageViewerState extends State<ReceiptImageViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    Matrix4 endMatrix;
    Offset position = _transformationController.toScene(
      Offset(50.w, 50.h),
    );

    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
        CurveTween(curve: Curves.easeInOut).animate(_animationController));

    _animationController.forward(from: 0).then((_) {
      _transformationController.value = endMatrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: widget.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading receipt...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onDoubleTap: _onDoubleTap,
              onTap: widget.onImageTap,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  if (_animation != null) {
                    _transformationController.value = _animation!.value;
                  }
                  return InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.5,
                    maxScale: 5.0,
                    constrained: false,
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      child: Center(
                        child: CustomImageWidget(
                          imageUrl: widget.imageUrl,
                          width: 100.w,
                          height: 80.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
