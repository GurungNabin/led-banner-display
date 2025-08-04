import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreatePreset;

  const EmptyStateWidget({
    Key? key,
    required this.onCreatePreset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LED Banner Illustration
            Container(
              width: 60.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  // LED Grid Background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: EmptyLEDGridPainter(),
                    ),
                  ),

                  // Center Icon
                  Center(
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.lightTheme.primaryColor,
                        size: 12.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No Presets Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Create your first LED banner preset to get started. Save your favorite configurations for quick access.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Create Preset Button
            SizedBox(
              width: 60.w,
              height: 6.h,
              child: ElevatedButton.icon(
                onPressed: onCreatePreset,
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Create Your First Preset',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary Action
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/banner-creator');
              },
              icon: Icon(
                Icons.play_arrow,
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
              label: Text(
                'Go to Banner Creator',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyLEDGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    const double dotSize = 1.5;
    const double spacing = 12.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          dotSize,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
