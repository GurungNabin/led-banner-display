import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DisplayPreferencesWidget extends StatefulWidget {
  final double brightness;
  final bool autoRotation;
  final String ledStyle;
  final Function(double) onBrightnessChanged;
  final Function(bool) onAutoRotationChanged;
  final Function(String) onLedStyleChanged;

  const DisplayPreferencesWidget({
    super.key,
    required this.brightness,
    required this.autoRotation,
    required this.ledStyle,
    required this.onBrightnessChanged,
    required this.onAutoRotationChanged,
    required this.onLedStyleChanged,
  });

  @override
  State<DisplayPreferencesWidget> createState() =>
      _DisplayPreferencesWidgetState();
}

class _DisplayPreferencesWidgetState extends State<DisplayPreferencesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Display Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          _buildBrightnessSlider(),
          _buildDivider(),
          _buildAutoRotationToggle(),
          _buildDivider(),
          _buildLedStyleSelector(),
        ],
      ),
    );
  }

  Widget _buildBrightnessSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Brightness',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${(widget.brightness * 100).round()}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
              inactiveTrackColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
              thumbColor: AppTheme.lightTheme.colorScheme.primary,
              overlayColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: widget.brightness,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: widget.onBrightnessChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoRotationToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto-Rotation',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Automatically rotate display based on device orientation',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.autoRotation,
            onChanged: widget.onAutoRotationChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildLedStyleSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LED Style',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildStyleOption('Dot Matrix', 'dot-matrix'),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStyleOption('Segment', 'segment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyleOption(String title, String value) {
    final bool isSelected = widget.ledStyle == value;

    return GestureDetector(
      onTap: () => widget.onLedStyleChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: value,
              groupValue: widget.ledStyle,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  widget.onLedStyleChanged(newValue);
                }
              },
              activeColor: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
      indent: 4.w,
      endIndent: 4.w,
    );
  }
}
