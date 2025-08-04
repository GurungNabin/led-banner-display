import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './preset_card_widget.dart';

class PresetListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> presets;
  final Function(Map<String, dynamic>) onPresetTap;
  final Function(Map<String, dynamic>) onPresetEdit;
  final Function(Map<String, dynamic>) onPresetDuplicate;
  final Function(Map<String, dynamic>) onPresetShare;
  final Function(Map<String, dynamic>) onPresetDelete;
  final bool isMultiSelectMode;
  final List<int> selectedPresetIds;
  final Function(int) onPresetSelect;

  const PresetListWidget({
    Key? key,
    required this.presets,
    required this.onPresetTap,
    required this.onPresetEdit,
    required this.onPresetDuplicate,
    required this.onPresetShare,
    required this.onPresetDelete,
    this.isMultiSelectMode = false,
    this.selectedPresetIds = const [],
    required this.onPresetSelect,
  }) : super(key: key);

  @override
  State<PresetListWidget> createState() => _PresetListWidgetState();
}

class _PresetListWidgetState extends State<PresetListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.presets.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 50.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 12.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'No presets found',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Try adjusting your search terms',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final preset = widget.presets[index];
          final presetId = preset['id'] as int? ?? index;
          final isSelected = widget.selectedPresetIds.contains(presetId);

          return GestureDetector(
            onLongPress: widget.isMultiSelectMode
                ? null
                : () => widget.onPresetSelect(presetId),
            child: PresetCardWidget(
              preset: preset,
              isSelected: isSelected,
              isMultiSelectMode: widget.isMultiSelectMode,
              onTap: () {
                if (widget.isMultiSelectMode) {
                  widget.onPresetSelect(presetId);
                } else {
                  widget.onPresetTap(preset);
                }
              },
              onEdit: () => widget.onPresetEdit(preset),
              onDuplicate: () => widget.onPresetDuplicate(preset),
              onShare: () => widget.onPresetShare(preset),
              onDelete: () => _showDeleteConfirmation(context, preset),
            ),
          );
        },
        childCount: widget.presets.length,
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> preset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.warning,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Delete Preset',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${preset['name'] ?? 'this preset'}"? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onPresetDelete(preset);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
