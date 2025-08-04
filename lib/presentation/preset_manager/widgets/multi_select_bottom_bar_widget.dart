import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MultiSelectBottomBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDeleteSelected;
  final VoidCallback onExportSelected;
  final VoidCallback onCancelSelection;

  const MultiSelectBottomBarWidget({
    Key? key,
    required this.selectedCount,
    required this.onDeleteSelected,
    required this.onExportSelected,
    required this.onCancelSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              // Selected count
              Expanded(
                child: Text(
                  '$selectedCount preset${selectedCount != 1 ? 's' : ''} selected',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),

              // Action buttons
              Row(
                children: [
                  // Export button
                  IconButton(
                    onPressed: selectedCount > 0 ? onExportSelected : null,
                    icon: Icon(
                      Icons.file_download,
                      color: selectedCount > 0
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                    tooltip: 'Export Selected',
                  ),

                  SizedBox(width: 2.w),

                  // Delete button
                  IconButton(
                    onPressed: selectedCount > 0 ? onDeleteSelected : null,
                    icon: Icon(
                      Icons.delete,
                      color: selectedCount > 0
                          ? AppTheme.error
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                    tooltip: 'Delete Selected',
                  ),

                  SizedBox(width: 2.w),

                  // Cancel button
                  TextButton(
                    onPressed: onCancelSelection,
                    child: Text(
                      'Cancel',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
