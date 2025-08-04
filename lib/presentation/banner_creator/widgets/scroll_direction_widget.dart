import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScrollDirectionWidget extends StatelessWidget {
  final String selectedDirection;
  final Function(String) onDirectionChanged;

  const ScrollDirectionWidget({
    Key? key,
    required this.selectedDirection,
    required this.onDirectionChanged,
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
          Text(
            'Scroll Direction',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDirectionOption(
                  'left',
                  'Left',
                  'arrow_back',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildDirectionOption(
                  'right',
                  'Right',
                  'arrow_forward',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildDirectionOption(
                  'up',
                  'Up',
                  'arrow_upward',
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildDirectionOption(
                  'down',
                  'Down',
                  'arrow_downward',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionOption(String value, String label, String iconName) {
    final isSelected = selectedDirection == value;

    return GestureDetector(
      onTap: () => onDirectionChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getIconData(iconName),
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'arrow_upward':
        return Icons.arrow_upward;
      case 'arrow_downward':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline;
    }
  }
}

