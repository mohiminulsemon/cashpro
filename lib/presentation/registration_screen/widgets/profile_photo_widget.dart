import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String? photoUrl;
  final Function(String) onPhotoSelected;

  const ProfilePhotoWidget({
    super.key,
    required this.photoUrl,
    required this.onPhotoSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Photo (Optional)',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Center(
          child: Stack(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: photoUrl != null
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 15.w,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showPhotoOptions(context),
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      photoUrl != null ? Icons.edit : Icons.camera_alt,
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Center(
          child: Text(
            photoUrl != null
                ? 'Tap to change photo'
                : 'Add a photo to personalize your profile',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Profile Photo',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Camera option
            ListTile(
              leading: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to capture a new photo'),
              onTap: () {
                Navigator.pop(context);
                _simulateCameraCapture(context);
              },
            ),

            // Gallery option
            ListTile(
              leading: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select an existing photo'),
              onTap: () {
                Navigator.pop(context);
                _simulateGallerySelection(context);
              },
            ),

            // Remove photo option (if photo exists)
            if (photoUrl != null)
              ListTile(
                leading: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CustomIconWidget(
                    iconName: 'delete',
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                title: const Text('Remove Photo'),
                subtitle: const Text('Remove current profile photo'),
                onTap: () {
                  Navigator.pop(context);
                  onPhotoSelected('');
                },
              ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _simulateCameraCapture(BuildContext context) {
    // In a real app, this would use the camera package
    // For demo purposes, we'll use a sample image
    final sampleImages = [
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1494790108755-2616c4f5fe6c?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    ];

    final selectedImage =
        sampleImages[DateTime.now().millisecond % sampleImages.length];
    onPhotoSelected(selectedImage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo captured successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _simulateGallerySelection(BuildContext context) {
    // In a real app, this would use the image_picker package
    // For demo purposes, we'll show a dialog with sample options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Profile Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a sample profile photo:'),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSamplePhotoOption(
                  context,
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                ),
                _buildSamplePhotoOption(
                  context,
                  'https://images.unsplash.com/photo-1494790108755-2616c4f5fe6c?w=150&h=150&fit=crop&crop=face',
                ),
                _buildSamplePhotoOption(
                  context,
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildSamplePhotoOption(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onPhotoSelected(imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo selected successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: ClipOval(
          child: CustomImageWidget(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
