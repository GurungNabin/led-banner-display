import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FullScreenDisplay extends StatefulWidget {
  const FullScreenDisplay({Key? key, this.bannerConfig}) : super(key: key);
  final Map<String, dynamic>? bannerConfig;

  @override
  State<FullScreenDisplay> createState() => _FullScreenDisplayState();
}

class _FullScreenDisplayState extends State<FullScreenDisplay>
    with TickerProviderStateMixin {
  AnimationController? _scrollController;
  AnimationController? _fadeController;
  Animation<double>? _scrollAnimation;
  Animation<double>? _fadeAnimation;

  Map<String, dynamic> bannerConfig = {
    'text': 'LED BANNER DISPLAY',
    'scrollDirection': 'left_to_right',
    'scrollSpeed': 50.0,
    'textColor': '#FF0000',
    'backgroundColor': '#000000',
    'fontSize': 24.0,
    'isFlashing': false,
    'soundEnabled': false,
  };

  bool _isPlaying = true;
  bool _showControls = false;
  bool _isMaxBrightness = false;
  Timer? _controlsTimer;
  Timer? _flashTimer;
  bool _flashVisible = true;

  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();

    if (widget.bannerConfig != null) {
      bannerConfig = {...bannerConfig, ...widget.bannerConfig!};
    }

    _setupAnimations();
    _enterFullScreen();
  }

  void _setupAnimations() {
    // Dispose existing controllers first
    _scrollController?.dispose();
    _fadeController?.dispose();

    final duration = Duration(
      milliseconds: (5000 / (bannerConfig['scrollSpeed'] as double)).round(),
    );

    _scrollController = AnimationController(
      duration: duration,
      vsync: this,
    );

    _scrollAnimation = Tween<double>(
      begin: _getScrollStartPosition(),
      end: _getScrollEndPosition(),
    ).animate(CurvedAnimation(
      parent: _scrollController!,
      curve: Curves.linear,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    ));

    if (_isPlaying) {
      _startScrolling();
    }

    if (bannerConfig['isFlashing'] as bool) {
      _setupFlashing();
    }
  }

  double _getScrollStartPosition() {
    switch (bannerConfig['scrollDirection']) {
      case 'left_to_right':
        return -100.w;
      case 'right_to_left':
        return 100.w;
      case 'up':
        return 100.h;
      case 'down':
        return -100.h;
      default:
        return -100.w;
    }
  }

  double _getScrollEndPosition() {
    switch (bannerConfig['scrollDirection']) {
      case 'left_to_right':
        return 100.w;
      case 'right_to_left':
        return -100.w;
      case 'up':
        return -100.h;
      case 'down':
        return 100.h;
      default:
        return 100.w;
    }
  }

  void _startScrolling() {
    _scrollController?.repeat();
  }

  void _setupFlashing() {
    _flashTimer?.cancel();
    _flashTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _flashVisible = !_flashVisible;
        });
      }
    });
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    if (_isMaxBrightness) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ));
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).pop();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _scrollController?.repeat();
    } else {
      _scrollController?.stop();
    }

    _hideControlsAfterDelay();
  }

  void _toggleBrightness() {
    setState(() {
      _isMaxBrightness = !_isMaxBrightness;
    });

    if (_isMaxBrightness) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ));
    }

    _hideControlsAfterDelay();
  }

  void _showControlsOverlay() {
    setState(() {
      _showControls = true;
    });
    _fadeController?.forward();
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController?.reverse().then((_) {
          if (mounted) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }
    });
  }

  Color _getTextColor() {
    final colorString = bannerConfig['textColor'] as String;
    return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
  }

  Color _getBackgroundColor() {
    final colorString = bannerConfig['backgroundColor'] as String;
    return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
  }

  Widget _buildLEDText() {
    final text = bannerConfig['text'] as String;
    final fontSize = (bannerConfig['fontSize'] as double).sp;
    final textColor = _getTextColor();
    final isFlashing = bannerConfig['isFlashing'] as bool;

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: isFlashing
            ? (_flashVisible ? textColor : Colors.transparent)
            : textColor,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
        shadows: [
          Shadow(
            color: textColor.withOpacity(0.5),
            blurRadius: 8.0,
            offset: const Offset(0, 0),
          ),
          Shadow(
            color: textColor.withOpacity(0.3),
            blurRadius: 16.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollingText() {
    return AnimatedBuilder(
      animation: _scrollAnimation!,
      builder: (context, child) {
        return Transform.translate(
          offset: _getTransformOffset(),
          child: _buildLEDText(),
        );
      },
    );
  }

  Offset _getTransformOffset() {
    final value = _scrollAnimation!.value;
    switch (bannerConfig['scrollDirection']) {
      case 'left_to_right':
      case 'right_to_left':
        return Offset(value, 0);
      case 'up':
      case 'down':
        return Offset(0, value);
      default:
        return Offset(value, 0);
    }
  }

  Widget _buildControlsOverlay() {
    return AnimatedBuilder(
      animation: _fadeAnimation!,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation!.value,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play/Pause Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 8.w,
                      ),
                      iconSize: 8.w,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Control Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brightness Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: _isMaxBrightness
                              ? AppTheme.warning
                              : Colors.grey[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: _toggleBrightness,
                          icon: Icon(
                            _isMaxBrightness
                                ? Icons.brightness_high
                                : Icons.brightness_medium,
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Exit Button
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: _exitFullScreen,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 6.w,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: GestureDetector(
        onTap: _showControlsOverlay,
        onDoubleTap: _toggleBrightness,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -500) {
            _exitFullScreen();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 500) {
            _exitFullScreen();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection:
                          _isVerticalScroll() ? Axis.vertical : Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: _buildScrollingText(),
                    ),
                  ),
                ),
              ),
              if (_showControls) _buildControlsOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  bool _isVerticalScroll() {
    final direction = bannerConfig['scrollDirection'] as String;
    return direction == 'up' || direction == 'down';
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _fadeController?.dispose();
    _controlsTimer?.cancel();
    _flashTimer?.cancel();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
