import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioSettingsWidget extends StatefulWidget {
  final double masterVolume;
  final bool soundEffects;
  final bool loopBeep;
  final Function(double) onMasterVolumeChanged;
  final Function(bool) onSoundEffectsChanged;
  final Function(bool) onLoopBeepChanged;
  final VoidCallback onTestSound;

  const AudioSettingsWidget({
    super.key,
    required this.masterVolume,
    required this.soundEffects,
    required this.loopBeep,
    required this.onMasterVolumeChanged,
    required this.onSoundEffectsChanged,
    required this.onLoopBeepChanged,
    required this.onTestSound,
  });

  @override
  State<AudioSettingsWidget> createState() => _AudioSettingsWidgetState();
}

class _AudioSettingsWidgetState extends State<AudioSettingsWidget> {
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
              'Audio Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          _buildMasterVolumeSlider(),
          _buildDivider(),
          _buildSoundEffectsToggle(),
          _buildDivider(),
          _buildLoopBeepToggle(),
          _buildDivider(),
          _buildTestSoundButton(),
        ],
      ),
    );
  }

  Widget _buildMasterVolumeSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Master Volume',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${(widget.masterVolume * 100).round()}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.volume_mute,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                    inactiveTrackColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    thumbColor: AppTheme.lightTheme.colorScheme.primary,
                    overlayColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    trackHeight: 4,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                  ),
                  child: Slider(
                    value: widget.masterVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: widget.onMasterVolumeChanged,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.volume_up,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundEffectsToggle() {
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
                  'Sound Effects',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Enable audio feedback for interactions',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.soundEffects,
            onChanged: widget.onSoundEffectsChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildLoopBeepToggle() {
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
                  'Loop Completion Beep',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Play sound when banner completes a scroll cycle',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.loopBeep,
            onChanged: widget.onLoopBeepChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildTestSoundButton() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: widget.onTestSound,
          icon: Icon(
            Icons.play_arrow,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          label: Text(
            'Test Sound',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
