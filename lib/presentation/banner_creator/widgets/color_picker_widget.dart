import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ColorPickerWidget extends StatelessWidget {
  final String title;
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const ColorPickerWidget({
    Key? key,
    required this.title,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 6.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildColorGrid(),
        ],
      ),
    );
  }

  Widget _buildColorGrid() {
    final colors = [
      // LED Colors
      AppTheme.ledRed,
      AppTheme.ledGreen,
      AppTheme.ledBlue,
      const Color(0xFFFFFF00), // Yellow
      const Color(0xFF00FFFF), // Cyan
      const Color(0xFFFF00FF), // Magenta
      const Color(0xFFFF8000), // Orange
      const Color(0xFFFFFFFF), // White
      // Standard Colors
      Colors.black,
      Colors.grey,
      const Color(0xFF800080), // Purple
      const Color(0xFF008000), // Dark Green
      const Color(0xFF000080), // Navy
      const Color(0xFF800000), // Maroon
      const Color(0xFF808000), // Olive
      const Color(0xFF008080), // Teal
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 1.h,
        childAspectRatio: 1,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        final isSelected = color.value == selectedColor.value;

        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Icon(
                      Icons.check,
                      color: _getContrastColor(color),
                      size: 16,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
