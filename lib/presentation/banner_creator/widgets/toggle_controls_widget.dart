// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../../core/app_export.dart';

// class ToggleControlsWidget extends StatelessWidget {
//   final bool isFlashing;
//   final bool soundEnabled;
//   final Function(bool) onFlashingChanged;
//   final Function(bool) onSoundChanged;

//   const ToggleControlsWidget({
//     Key? key,
//     required this.isFlashing,
//     required this.soundEnabled,
//     required this.onFlashingChanged,
//     required this.onSoundChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: AppTheme.lightTheme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppTheme.lightTheme.colorScheme.outline,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Effects',
//             style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 2.h),
//           _buildToggleOption(
//             'Flashing Text',
//             'flash_on',
//             isFlashing,
//             onFlashingChanged,
//           ),
//           SizedBox(height: 2.h),
//           _buildToggleOption(
//             'Sound Effects',
//             soundEnabled ? 'volume_up' : 'volume_off',
//             soundEnabled,
//             onSoundChanged,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToggleOption(
//     String title,
//     String iconName,
//     bool value,
//     Function(bool) onChanged,
//   ) {
//     IconData iconData;
//     switch (iconName) {
//       case 'flash_on':
//         iconData = Icons.flash_on;
//         break;
//       case 'volume_up':
//         iconData = Icons.volume_up;
//         break;
//       case 'volume_off':
//         iconData = Icons.volume_off;
//         break;
//       default:
//         iconData = Icons.help_outline;
//     }
//     return Row(
//       children: [
//         Icon(
//           iconData,
//           color: value
//               ? AppTheme.lightTheme.colorScheme.primary
//               : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
//           size: 24,
//         ),
//         SizedBox(width: 3.w),
//         Expanded(
//           child: Text(
//             title,
//             style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
//               color: value
//                   ? AppTheme.lightTheme.colorScheme.primary
//                   : AppTheme.lightTheme.colorScheme.onSurface,
//             ),
//           ),
//         ),
//         Switch(
//           value: value,
//           onChanged: onChanged,
//           activeColor: AppTheme.lightTheme.colorScheme.primary,
//           activeTrackColor:
//               AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.5),
//           inactiveThumbColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
//           inactiveTrackColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant
//               .withValues(alpha: 0.3),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToggleControlsWidget extends StatelessWidget {
  final bool isFlashing;
  final bool isGlowing; // Added for glow toggle
  final bool soundEnabled;
  final ValueChanged<bool> onFlashingChanged;
  final ValueChanged<bool> onGlowingChanged; // Added for glow callback
  final ValueChanged<bool> onSoundChanged;

  const ToggleControlsWidget({
    Key? key,
    required this.isFlashing,
    required this.isGlowing, // Added to constructor
    required this.soundEnabled,
    required this.onFlashingChanged,
    required this.onGlowingChanged, // Added to constructor
    required this.onSoundChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToggleRow(
          icon: Icons.flash_on,
          label: 'Flashing Effect',
          value: isFlashing,
          onChanged: onFlashingChanged,
        ),
        SizedBox(height: 2.h),
        _buildToggleRow(
          icon: Icons.lightbulb_outline,
          label: 'Glow Effect',
          value: isGlowing,
          onChanged: onGlowingChanged,
        ),
        SizedBox(height: 2.h),
        _buildToggleRow(
          icon: Icons.volume_up,
          label: 'Sound Effect',
          value: soundEnabled,
          onChanged: onSoundChanged,
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF667eea),
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF667eea),
          inactiveThumbColor: const Color(0xFF718096),
          inactiveTrackColor: const Color(0xFFE2E8F0),
        ),
      ],
    );
  }
}