import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PresetCardWidget extends StatefulWidget {
  final Map<String, dynamic> preset;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final bool isSelected;
  final bool isMultiSelectMode;

  const PresetCardWidget({
    Key? key,
    required this.preset,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onShare,
    required this.onDelete,
    this.isSelected = false,
    this.isMultiSelectMode = false,
  }) : super(key: key);

  @override
  State<PresetCardWidget> createState() => _PresetCardWidgetState();
}

class _PresetCardWidgetState extends State<PresetCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _startAnimation();
  }

  void _startAnimation() {
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String presetName = widget.preset['name'] as String? ?? 'Untitled';
    final String presetText = widget.preset['text'] as String? ?? 'Sample Text';
    final String createdDate =
        widget.preset['createdDate'] as String? ?? '2025-08-02';
    final Color textColor =
        Color(widget.preset['textColor'] as int? ?? 0xFFFF3333);
    final Color backgroundColor =
        Color(widget.preset['backgroundColor'] as int? ?? 0xFF000000);
    final String scrollDirection =
        widget.preset['scrollDirection'] as String? ?? 'left_to_right';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: widget.isSelected ? 8 : 2,
        color: widget.isSelected
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: widget.isSelected
              ? BorderSide(color: AppTheme.lightTheme.primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and selection indicator
                Row(
                  children: [
                    if (widget.isMultiSelectMode) ...[
                      Container(
                        width: 6.w,
                        height: 6.w,
                        margin: EdgeInsets.only(right: 3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : Colors.transparent,
                          border: Border.all(
                            color: widget.isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.dividerColor,
                            width: 2,
                          ),
                        ),
                        child: widget.isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 3.w,
                              )
                            : null,
                      ),
                    ],
                    Expanded(
                      child: Text(
                        presetName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            widget.onEdit();
                            break;
                          case 'duplicate':
                            widget.onDuplicate();
                            break;
                          case 'share':
                            widget.onShare();
                            break;
                          case 'delete':
                            widget.onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(
                                Icons.content_copy,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppTheme.error,
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Delete',
                                style: TextStyle(color: AppTheme.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
                        Icons.more_vert,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // LED Preview Container
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        // LED Grid Background
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CustomPaint(
                            painter: LEDGridPainter(
                              backgroundColor: backgroundColor,
                              dotColor: textColor.withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                        // Animated Text
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 6.h,
                            child: ClipRect(
                              child: AnimatedBuilder(
                                animation: _slideAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      _slideAnimation.value.dx * 80.w,
                                      0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        presetText,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                          letterSpacing: 2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Preset Details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created: $createdDate',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: textColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightTheme.dividerColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Icon(
                                _getIconDataFromName(
                                    _getScrollDirectionIcon(scrollDirection)),
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 4.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getScrollDirectionIcon(String direction) {
    switch (direction) {
      case 'left_to_right':
        return 'arrow_forward';
      case 'right_to_left':
        return 'arrow_back';
      case 'up':
        return 'arrow_upward';
      case 'down':
        return 'arrow_downward';
      default:
        return 'arrow_forward';
    }
  }

  IconData _getIconDataFromName(String iconName) {
    switch (iconName) {
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_upward':
        return Icons.arrow_upward;
      case 'arrow_downward':
        return Icons.arrow_downward;
      default:
        return Icons.arrow_forward;
    }
  }
}

class LEDGridPainter extends CustomPainter {
  final Color backgroundColor;
  final Color dotColor;

  LEDGridPainter({
    required this.backgroundColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double dotSize = 2.0;
    const double spacing = 8.0;

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
