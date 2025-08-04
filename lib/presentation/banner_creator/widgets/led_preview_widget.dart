import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LedPreviewWidget extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final String scrollDirection;
  final double scrollSpeed;
  final bool isFlashing;
  final String fontStyle;
  final bool isPlaying;

  const LedPreviewWidget({
    Key? key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.scrollDirection,
    required this.scrollSpeed,
    required this.isFlashing,
    required this.fontStyle,
    required this.isPlaying,
  }) : super(key: key);

  @override
  State<LedPreviewWidget> createState() => _LedPreviewWidgetState();
}

class _LedPreviewWidgetState extends State<LedPreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _flashController;
  late Animation<double> _scrollAnimation;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scrollController = AnimationController(
      duration: Duration(milliseconds: (3000 / widget.scrollSpeed).round()),
      vsync: this,
    );

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scrollAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scrollController,
      curve: Curves.linear,
    ));

    _flashAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flashController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPlaying) {
      _scrollController.repeat();
    }

    if (widget.isFlashing) {
      _flashController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LedPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollSpeed != widget.scrollSpeed) {
      _scrollController.duration = Duration(
        milliseconds: (3000 / widget.scrollSpeed).round(),
      );
    }

    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _scrollController.repeat();
      } else {
        _scrollController.stop();
      }
    }

    if (oldWidget.isFlashing != widget.isFlashing) {
      if (widget.isFlashing) {
        _flashController.repeat(reverse: true);
      } else {
        _flashController.stop();
        _flashController.reset();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AnimatedBuilder(
          animation: Listenable.merge([_scrollAnimation, _flashAnimation]),
          builder: (context, child) {
            return CustomPaint(
              painter: LedTextPainter(
                text: widget.text.isEmpty ? 'LED BANNER' : widget.text,
                textColor: widget.textColor,
                fontSize: widget.fontSize,
                scrollDirection: widget.scrollDirection,
                scrollProgress: _scrollAnimation.value,
                opacity: widget.isFlashing ? _flashAnimation.value : 1.0,
                fontStyle: widget.fontStyle,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class LedTextPainter extends CustomPainter {
  final String text;
  final Color textColor;
  final double fontSize;
  final String scrollDirection;
  final double scrollProgress;
  final double opacity;
  final String fontStyle;

  LedTextPainter({
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.scrollDirection,
    required this.scrollProgress,
    required this.opacity,
    required this.fontStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    if (fontStyle == 'dot-matrix') {
      _paintDotMatrix(canvas, size, paint);
    } else {
      _paintSegmentDisplay(canvas, size, paint);
    }
  }

  void _paintDotMatrix(Canvas canvas, Size size, Paint paint) {
    final dotSize = fontSize / 8;
    final spacing = dotSize * 1.5;
    final textWidth = text.length * spacing * 6;

    double startX = 0;
    double startY = size.height / 2 - (fontSize / 2);

    switch (scrollDirection) {
      case 'left':
        startX = size.width - (scrollProgress * (size.width + textWidth));
        break;
      case 'right':
        startX = -textWidth + (scrollProgress * (size.width + textWidth));
        break;
      case 'up':
        startY = size.height - (scrollProgress * (size.height + fontSize));
        startX = (size.width - textWidth) / 2;
        break;
      case 'down':
        startY = -fontSize + (scrollProgress * (size.height + fontSize));
        startX = (size.width - textWidth) / 2;
        break;
    }

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final charX = startX + (i * spacing * 6);
      _drawDotMatrixChar(canvas, char, charX, startY, dotSize, paint);
    }
  }

  void _drawDotMatrixChar(Canvas canvas, String char, double x, double y,
      double dotSize, Paint paint) {
    final patterns = _getDotMatrixPatterns();
    final pattern = patterns[char.toUpperCase()] ?? patterns['?']!;

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawCircle(
            Offset(x + col * dotSize * 1.5, y + row * dotSize * 1.5),
            dotSize / 2,
            paint,
          );
        }
      }
    }
  }

  void _paintSegmentDisplay(Canvas canvas, Size size, Paint paint) {
    final segmentWidth = fontSize * 0.8;
    final segmentHeight = fontSize * 0.1;
    final charWidth = segmentWidth * 1.2;
    final textWidth = text.length * charWidth;

    double startX = 0;
    double startY = size.height / 2 - (fontSize / 2);

    switch (scrollDirection) {
      case 'left':
        startX = size.width - (scrollProgress * (size.width + textWidth));
        break;
      case 'right':
        startX = -textWidth + (scrollProgress * (size.width + textWidth));
        break;
      case 'up':
        startY = size.height - (scrollProgress * (size.height + fontSize));
        startX = (size.width - textWidth) / 2;
        break;
      case 'down':
        startY = -fontSize + (scrollProgress * (size.height + fontSize));
        startX = (size.width - textWidth) / 2;
        break;
    }

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final charX = startX + (i * charWidth);
      _drawSegmentChar(
          canvas, char, charX, startY, segmentWidth, segmentHeight, paint);
    }
  }

  void _drawSegmentChar(Canvas canvas, String char, double x, double y,
      double width, double height, Paint paint) {
    final segments = _getSegmentPatterns();
    final pattern = segments[char.toUpperCase()] ?? segments['8']!;

    // Draw 7-segment display
    if (pattern[0] == 1)
      _drawHorizontalSegment(canvas, x, y, width, height, paint); // Top
    if (pattern[1] == 1)
      _drawVerticalSegment(
          canvas, x + width, y, height, width / 8, paint); // Top right
    if (pattern[2] == 1)
      _drawVerticalSegment(canvas, x + width, y + width / 2, height, width / 8,
          paint); // Bottom right
    if (pattern[3] == 1)
      _drawHorizontalSegment(
          canvas, x, y + width, width, height, paint); // Bottom
    if (pattern[4] == 1)
      _drawVerticalSegment(
          canvas, x, y + width / 2, height, width / 8, paint); // Bottom left
    if (pattern[5] == 1)
      _drawVerticalSegment(canvas, x, y, height, width / 8, paint); // Top left
    if (pattern[6] == 1)
      _drawHorizontalSegment(
          canvas, x, y + width / 2, width, height, paint); // Middle
  }

  void _drawHorizontalSegment(Canvas canvas, double x, double y, double width,
      double height, Paint paint) {
    final path = Path();
    path.moveTo(x + height, y);
    path.lineTo(x + width - height, y);
    path.lineTo(x + width, y + height / 2);
    path.lineTo(x + width - height, y + height);
    path.lineTo(x + height, y + height);
    path.lineTo(x, y + height / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawVerticalSegment(Canvas canvas, double x, double y, double height,
      double width, Paint paint) {
    final path = Path();
    path.moveTo(x, y + width);
    path.lineTo(x + width / 2, y);
    path.lineTo(x + width, y + width);
    path.lineTo(x + width, y + height - width);
    path.lineTo(x + width / 2, y + height);
    path.lineTo(x, y + height - width);
    path.close();
    canvas.drawPath(path, paint);
  }

  Map<String, List<List<int>>> _getDotMatrixPatterns() {
    return {
      'A': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
      ],
      'B': [
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
      ],
      'C': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      'D': [
        [1, 1, 1, 0, 0],
        [1, 0, 0, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 1, 0],
        [1, 1, 1, 0, 0],
      ],
      'E': [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
      ],
      'F': [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
      ],
      'G': [
        [0, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      'H': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
      ],
      'I': [
        [1, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 1],
      ],
      'J': [
        [0, 0, 1, 1, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 1, 0],
        [1, 0, 0, 1, 0],
        [1, 0, 0, 1, 0],
        [0, 1, 1, 0, 0],
      ],
      'K': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 1, 0],
        [1, 0, 1, 0, 0],
        [1, 1, 0, 0, 0],
        [1, 0, 1, 0, 0],
        [1, 0, 0, 1, 0],
        [1, 0, 0, 0, 1],
      ],
      'L': [
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
      ],
      'M': [
        [1, 0, 0, 0, 1],
        [1, 1, 0, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
      ],
      'N': [
        [1, 0, 0, 0, 1],
        [1, 1, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
      ],
      'O': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      'P': [
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
      ],
      'Q': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 1, 0],
        [0, 1, 1, 0, 1],
      ],
      'R': [
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
        [1, 0, 1, 0, 0],
        [1, 0, 0, 1, 0],
        [1, 0, 0, 0, 1],
      ],
      'S': [
        [0, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
      ],
      'T': [
        [1, 1, 1, 1, 1],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
      ],
      'U': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      'V': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0],
        [0, 0, 1, 0, 0],
      ],
      'W': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 1, 0, 1, 1],
        [1, 1, 0, 1, 1],
        [1, 0, 0, 0, 1],
      ],
      'X': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 1, 0, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
      ],
      'Y': [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
      ],
      'Z': [
        [1, 1, 1, 1, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
      ],

      '0': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      '1': [
        [0, 0, 1, 0, 0],
        [0, 1, 1, 0, 0],
        [1, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [1, 1, 1, 1, 1],
      ],
      '2': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 1, 0, 0, 0],
        [1, 1, 1, 1, 1],
      ],
      '3': [
        [1, 1, 1, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 1, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      '4': [
        [0, 0, 0, 1, 0],
        [0, 0, 1, 1, 0],
        [0, 1, 0, 1, 0],
        [1, 0, 0, 1, 0],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 1, 0],
      ],
      '5': [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      '6': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      '7': [
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 0, 0],
      ],
      '8': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],
      '9': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
      ],

      ' ': [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],
      '?': [
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0],
      ],
      '.': [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
      ',': [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [0, 1, 0],
        [0, 1, 0],
        [1, 0, 0],
      ],
      '!': [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0],
      ],
      '-': [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ],

      // Add more symbols here if you want
    };
  }

  Map<String, List<int>> _getSegmentPatterns() {
    return {
      '0': [1, 1, 1, 1, 1, 1, 0],
      '1': [0, 1, 1, 0, 0, 0, 0],
      '2': [1, 1, 0, 1, 1, 0, 1],
      '3': [1, 1, 1, 1, 0, 0, 1],
      '4': [0, 1, 1, 0, 0, 1, 1],
      '5': [1, 0, 1, 1, 0, 1, 1],
      '6': [1, 0, 1, 1, 1, 1, 1],
      '7': [1, 1, 1, 0, 0, 0, 0],
      '8': [1, 1, 1, 1, 1, 1, 1],
      '9': [1, 1, 1, 1, 0, 1, 1],
      'A': [1, 1, 1, 0, 1, 1, 1],
      'B': [0, 0, 1, 1, 1, 1, 1],
      'C': [1, 0, 0, 1, 1, 1, 0],
      'D': [0, 1, 1, 1, 1, 0, 1],
      'E': [1, 0, 0, 1, 1, 1, 1],
      'F': [1, 0, 0, 0, 1, 1, 1],
      'L': [0, 0, 0, 1, 1, 1, 0],
      'N': [0, 0, 1, 0, 1, 0, 1],
      'R': [0, 0, 0, 0, 1, 0, 1],
      ' ': [0, 0, 0, 0, 0, 0, 0],
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
