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

  LedTextPainter({
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.scrollDirection,
    required this.scrollProgress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor.withValues(alpha: opacity),
          fontFamily: 'Courier', // Pixel-style font for LED-like appearance
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;

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

    textPainter.paint(canvas, Offset(startX, startY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
