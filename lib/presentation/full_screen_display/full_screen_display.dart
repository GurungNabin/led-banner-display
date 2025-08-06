// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';

// import '../../../core/app_export.dart';

// class FullScreenDisplay extends StatefulWidget {
//   const FullScreenDisplay({Key? key, this.bannerConfig}) : super(key: key);
//   final Map<String, dynamic>? bannerConfig;

//   @override
//   State<FullScreenDisplay> createState() => _FullScreenDisplayState();
// }

// class _FullScreenDisplayState extends State<FullScreenDisplay>
//     with TickerProviderStateMixin {
//   AnimationController? _scrollController;
//   AnimationController? _fadeController;
//   Animation<double>? _scrollAnimation;
//   Animation<double>? _fadeAnimation;

//   Map<String, dynamic> bannerConfig = {
//     'text': 'LED BANNER DISPLAY',
//     'scrollDirection': 'left_to_right',
//     'scrollSpeed': 50.0,
//     'textColor': '#FF0000',
//     'backgroundColor': '#000000',
//     'fontSize': 24.0,
//     'isFlashing': false,
//     'soundEnabled': false,
//   };

//   bool _isPlaying = true;
//   bool _showControls = false;
//   bool _isMaxBrightness = false;
//   Timer? _controlsTimer;
//   Timer? _flashTimer;
//   bool _flashVisible = true;

//   double screenWidth = 0;
//   double screenHeight = 0;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.bannerConfig != null) {
//       bannerConfig = {...bannerConfig, ...widget.bannerConfig!};
//     }

//     _setupAnimations();
//     _enterFullScreen();

//     // Forece landscape orientation
//     // SystemChrome.setPreferredOrientations([
//     //   DeviceOrientation.landscapeLeft,
//     //   DeviceOrientation.landscapeRight,
//     // ]);
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//   }

//   void _setupAnimations() {
//     // Dispose existing controllers first
//     _scrollController?.dispose();
//     _fadeController?.dispose();

//     final duration = Duration(
//       milliseconds: (5000 / (bannerConfig['scrollSpeed'] as double)).round(),
//     );

//     _scrollController = AnimationController(
//       duration: duration,
//       vsync: this,
//     );

//     _scrollAnimation = Tween<double>(
//       begin: _getScrollStartPosition(),
//       end: _getScrollEndPosition(),
//     ).animate(CurvedAnimation(
//       parent: _scrollController!,
//       curve: Curves.linear,
//     ));

//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController!,
//       curve: Curves.easeInOut,
//     ));

//     if (_isPlaying) {
//       _startScrolling();
//     }

//     if (bannerConfig['isFlashing'] as bool) {
//       _setupFlashing();
//     }
//   }

//   double _getScrollStartPosition() {
//     switch (bannerConfig['scrollDirection']) {
//       case 'left_to_right':
//         return -100.w;
//       case 'right_to_left':
//         return 100.w;
//       case 'up':
//         return 100.h;
//       case 'down':
//         return -100.h;
//       default:
//         return -100.w;
//     }
//   }

//   double _getScrollEndPosition() {
//     switch (bannerConfig['scrollDirection']) {
//       case 'left_to_right':
//         return 100.w;
//       case 'right_to_left':
//         return -100.w;
//       case 'up':
//         return -100.h;
//       case 'down':
//         return 100.h;
//       default:
//         return 100.w;
//     }
//   }

//   void _startScrolling() {
//     _scrollController?.repeat();
//   }

//   void _setupFlashing() {
//     _flashTimer?.cancel();
//     _flashTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (mounted) {
//         setState(() {
//           _flashVisible = !_flashVisible;
//         });
//       }
//     });
//   }

//   // void _enterFullScreen() {
//   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//   //   if (_isMaxBrightness) {
//   //     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//   //       statusBarBrightness: Brightness.light,
//   //     ));
//   //   }

//   //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//   //     statusBarColor: Colors.transparent,
//   //     systemNavigationBarColor: Colors.transparent,
//   //   ));
//   // }

//   void _enterFullScreen() {
//     // Set landscape orientation
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     if (_isMaxBrightness) {
//       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         statusBarBrightness: Brightness.light,
//       ));
//     }

//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: Colors.transparent,
//     ));
//   }

//   // void _exitFullScreen() async {
//   //   // Reset orientation BEFORE popping
//   //   await SystemChrome.setPreferredOrientations([
//   //     DeviceOrientation.portraitUp,
//   //     DeviceOrientation.portraitDown,
//   //   ]);
//   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   //   Navigator.of(context).pop();
//   // }

//   void _exitFullScreen() async {
//     // 1. Set back to portrait orientation
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     // 2. Restore system UI
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//     // 3. Wait a moment for orientation change to take effect
//     await Future.delayed(const Duration(milliseconds: 300));

//     // 4. Now safely pop the screen
//     if (mounted) {
//       Navigator.of(context).pop();
//     }
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });

//     if (_isPlaying) {
//       _scrollController?.repeat();
//     } else {
//       _scrollController?.stop();
//     }

//     _hideControlsAfterDelay();
//   }

//   void _toggleBrightness() {
//     setState(() {
//       _isMaxBrightness = !_isMaxBrightness;
//     });

//     if (_isMaxBrightness) {
//       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         statusBarBrightness: Brightness.light,
//       ));
//     } else {
//       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//         statusBarBrightness: Brightness.dark,
//       ));
//     }

//     _hideControlsAfterDelay();
//   }

//   void _showControlsOverlay() {
//     setState(() {
//       _showControls = true;
//     });
//     _fadeController?.forward();
//     _hideControlsAfterDelay();
//   }

//   void _hideControlsAfterDelay() {
//     _controlsTimer?.cancel();
//     _controlsTimer = Timer(const Duration(seconds: 3), () {
//       if (mounted) {
//         _fadeController?.reverse().then((_) {
//           if (mounted) {
//             setState(() {
//               _showControls = false;
//             });
//           }
//         });
//       }
//     });
//   }

//   Color _getTextColor() {
//     final colorString = bannerConfig['textColor'] as String;
//     return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
//   }

//   Color _getBackgroundColor() {
//     final colorString = bannerConfig['backgroundColor'] as String;
//     return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
//   }

//   Widget _buildLEDText() {
//     final text = bannerConfig['text'] as String;
//     final fontSize = (bannerConfig['fontSize'] as double).sp;
//     final textColor = _getTextColor();
//     final isFlashing = bannerConfig['isFlashing'] as bool;

//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: fontSize,
//         fontWeight: FontWeight.bold,
//         color: isFlashing
//             ? (_flashVisible ? textColor : Colors.transparent)
//             : textColor,
//         fontFamily: 'monospace',
//         letterSpacing: 2.0,
//         shadows: [
//           Shadow(
//             color: textColor.withOpacity(0.5),
//             blurRadius: 8.0,
//             offset: const Offset(0, 0),
//           ),
//           Shadow(
//             color: textColor.withOpacity(0.3),
//             blurRadius: 16.0,
//             offset: const Offset(0, 0),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScrollingText() {
//     return AnimatedBuilder(
//       animation: _scrollAnimation!,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: _getTransformOffset(),
//           child: _buildLEDText(),
//         );
//       },
//     );
//   }

//   Offset _getTransformOffset() {
//     final value = _scrollAnimation!.value;
//     switch (bannerConfig['scrollDirection']) {
//       case 'left_to_right':
//       case 'right_to_left':
//         return Offset(value, 0);
//       case 'up':
//       case 'down':
//         return Offset(0, value);
//       default:
//         return Offset(value, 0);
//     }
//   }

//   Widget _buildControlsOverlay() {
//     return AnimatedBuilder(
//       animation: _fadeAnimation!,
//       builder: (context, child) {
//         return Opacity(
//           opacity: _fadeAnimation!.value,
//           child: Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Play/Pause Button
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppTheme.lightTheme.primaryColor,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       onPressed: _togglePlayPause,
//                       icon: Icon(
//                         _isPlaying ? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                         size: 8.w,
//                       ),
//                       iconSize: 8.w,
//                     ),
//                   ),

//                   SizedBox(height: 4.h),

//                   // Control Buttons Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Brightness Toggle
//                       Container(
//                         decoration: BoxDecoration(
//                           color: _isMaxBrightness
//                               ? AppTheme.warning
//                               : Colors.grey[600],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: IconButton(
//                           onPressed: _toggleBrightness,
//                           icon: Icon(
//                             _isMaxBrightness
//                                 ? Icons.brightness_high
//                                 : Icons.brightness_medium,
//                             color: Colors.white,
//                             size: 6.w,
//                           ),
//                         ),
//                       ),

//                       SizedBox(width: 4.w),

//                       // Exit Button
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppTheme.error,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: IconButton(
//                           onPressed: _exitFullScreen,
//                           icon: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 6.w,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: _getBackgroundColor(),
//       body: GestureDetector(
//         onTap: _showControlsOverlay,
//         onDoubleTap: _toggleBrightness,
//         onVerticalDragEnd: (details) {
//           if (details.primaryVelocity != null &&
//               details.primaryVelocity! < -500) {
//             _exitFullScreen();
//           }
//         },
//         onHorizontalDragEnd: (details) {
//           if (details.primaryVelocity != null &&
//               details.primaryVelocity!.abs() > 500) {
//             _exitFullScreen();
//           }
//         },
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: Stack(
//             children: [
//               Center(
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   child: Center(
//                     child: SingleChildScrollView(
//                       scrollDirection:
//                           _isVerticalScroll() ? Axis.vertical : Axis.horizontal,
//                       physics: const NeverScrollableScrollPhysics(),
//                       child: _buildScrollingText(),
//                     ),
//                   ),
//                 ),
//               ),
//               if (_showControls) _buildControlsOverlay(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool _isVerticalScroll() {
//     final direction = bannerConfig['scrollDirection'] as String;
//     return direction == 'up' || direction == 'down';
//   }

//   // @override
//   // void dispose() {
//   //   _scrollController?.dispose();
//   //   _fadeController?.dispose();
//   //   _controlsTimer?.cancel();
//   //   _flashTimer?.cancel();

//   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//   //   super.dispose();
//   // }

//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     _fadeController?.dispose();
//     _controlsTimer?.cancel();
//     _flashTimer?.cancel();

//     // Restore portrait + UI mode just in case
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

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
  AnimationController? _glowController;
  AnimationController? _bounceController;
  Animation<double>? _scrollAnimation;
  Animation<double>? _fadeAnimation;
  Animation<double>? _glowAnimation;
  Animation<double>? _bounceAnimation;

  Map<String, dynamic> bannerConfig = {
    'text': 'LED BANNER DISPLAY',
    'scrollDirection': 'left_to_right',
    'scrollSpeed': 50.0,
    'textColor': '#FF0000',
    'backgroundColor': '#000000',
    'fontSize': 24.0,
    'isFlashing': false,
    'soundEnabled': false,
    'fontStyle': 'dot-matrix',
  };

  bool _isPlaying = true;
  bool _showControls = false;
  bool _isMaxBrightness = false;
  Timer? _controlsTimer;
  Timer? _flashTimer;
  Timer? _hideTimer;
  bool _flashVisible = true;
  int _tapCount = 0;

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
    _startHideTimer();
  }

  void _setupAnimations() {
    // Dispose existing controllers first
    _scrollController?.dispose();
    _fadeController?.dispose();
    _glowController?.dispose();
    _bounceController?.dispose();

    final duration = Duration(
      milliseconds: (8000 / (bannerConfig['scrollSpeed'] as double)).round(),
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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    ));

    // Glow effect animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController!,
      curve: Curves.easeInOut,
    ));

    // Bounce effect for interactions
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _bounceController!,
      curve: Curves.elasticOut,
    ));

    if (_isPlaying) {
      _startScrolling();
    }

    if (bannerConfig['isFlashing'] as bool) {
      _setupFlashing();
    }

    _glowController?.repeat(reverse: true);
  }

  double _getScrollStartPosition() {
    switch (bannerConfig['scrollDirection']) {
      case 'left_to_right':
        return -150.w;
      case 'right_to_left':
        return 150.w;
      case 'up':
        return 150.h;
      case 'down':
        return -150.h;
      default:
        return -150.w;
    }
  }

  double _getScrollEndPosition() {
    switch (bannerConfig['scrollDirection']) {
      case 'left_to_right':
        return 150.w;
      case 'right_to_left':
        return -150.w;
      case 'up':
        return -150.h;
      case 'down':
        return 150.h;
      default:
        return 150.w;
    }
  }

  void _startScrolling() {
    _scrollController?.repeat();
  }

  void _setupFlashing() {
    _flashTimer?.cancel();
    _flashTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _flashVisible = !_flashVisible;
        });
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showControls) {
        _hideControlsOverlay();
      }
    });
  }

  void _enterFullScreen() {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness:
          _isMaxBrightness ? Brightness.light : Brightness.dark,
    ));
  }

  void _exitFullScreen() async {
    // Show exit animation
    _bounceController?.forward().then((_) async {
      // 1. Set back to portrait orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 2. Restore system UI
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // 3. Wait a moment for orientation change to take effect
      await Future.delayed(const Duration(milliseconds: 300));

      // 4. Now safely pop the screen
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
    _bounceController?.forward().then((_) => _bounceController?.reverse());
  }

  void _toggleBrightness() {
    setState(() {
      _isMaxBrightness = !_isMaxBrightness;
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness:
          _isMaxBrightness ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    _hideControlsAfterDelay();
    _bounceController?.forward().then((_) => _bounceController?.reverse());
  }

  void _showControlsOverlay() {
    setState(() {
      _showControls = true;
    });
    _fadeController?.forward();
    _hideControlsAfterDelay();
  }

  void _hideControlsOverlay() {
    _fadeController?.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _hideControlsAfterDelay() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        _hideControlsOverlay();
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
    final fontStyle = bannerConfig['fontStyle'] as String? ?? 'dot-matrix';

    return AnimatedBuilder(
      animation: _glowAnimation!,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _bounceAnimation!,
          builder: (context, child) {
            return Transform.scale(
              scale: _bounceAnimation!.value,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // Dynamic glow effect
                    BoxShadow(
                      color: textColor
                          .withOpacity(0.3 + (_glowAnimation!.value * 0.4)),
                      blurRadius: 20 + (_glowAnimation!.value * 15),
                      spreadRadius: 2 + (_glowAnimation!.value * 3),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontStyle == 'segment'
                        ? FontWeight.w900
                        : FontWeight.bold,
                    color: isFlashing
                        ? (_flashVisible
                            ? textColor
                            : textColor.withOpacity(0.3))
                        : textColor,
                    fontFamily:
                        fontStyle == 'segment' ? 'Courier' : 'monospace',
                    letterSpacing: fontStyle == 'segment' ? 4.0 : 2.0,
                    height: 1.2,
                    shadows: [
                      // Inner glow
                      Shadow(
                        color: textColor.withOpacity(0.8),
                        blurRadius: 5.0,
                        offset: const Offset(0, 0),
                      ),
                      // Outer glow
                      Shadow(
                        color: textColor.withOpacity(0.4),
                        blurRadius: 15.0,
                        offset: const Offset(0, 0),
                      ),
                      // Far glow
                      Shadow(
                        color: textColor.withOpacity(0.2),
                        blurRadius: 30.0,
                        offset: const Offset(0, 0),
                      ),
                      // Directional shadow for depth
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8.0,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main play/pause button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isPlaying
                                ? [Colors.orange[400]!, Colors.red[400]!]
                                : [Colors.green[400]!, Colors.teal[400]!],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isPlaying ? Colors.orange : Colors.green)
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Icon(
                                _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Control buttons row
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Brightness toggle
                            _buildControlButton(
                              icon: _isMaxBrightness
                                  ? Icons.brightness_high_rounded
                                  : Icons.brightness_medium_rounded,
                              label: 'Brightness',
                              isActive: _isMaxBrightness,
                              activeColor: Colors.amber,
                              onPressed: _toggleBrightness,
                            ),

                            SizedBox(width: 8.w),

                            // Speed indicator
                            _buildInfoChip(
                                '${bannerConfig['scrollSpeed']}x Speed'),

                            SizedBox(width: 8.w),

                            // Exit button
                            _buildControlButton(
                              icon: Icons.close_rounded,
                              label: 'Exit',
                              isActive: false,
                              activeColor: Colors.red,
                              onPressed: _exitFullScreen,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Gesture hints
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Tap to show controls • Double tap for brightness • Swipe to exit',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: isActive
                ? Border.all(color: activeColor.withOpacity(0.5))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : Colors.white,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? activeColor : Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue[200],
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleTap() {
    _tapCount++;

    if (_tapCount == 1) {
      // Single tap - show/hide controls
      if (_showControls) {
        _hideControlsOverlay();
      } else {
        _showControlsOverlay();
      }

      // Reset tap count after delay
      Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      // Double tap - toggle brightness
      _toggleBrightness();
      _tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final backgroundColor = _getBackgroundColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: _handleTap,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -800) {
            _exitFullScreen();
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 800) {
            _exitFullScreen();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                backgroundColor.withOpacity(0.8),
                backgroundColor,
                Colors.black,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern (subtle LED grid effect)
              if (!_isMaxBrightness)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'data:image/svg+xml,${Uri.encodeComponent(_getLEDPatternSVG())}'),
                      repeat: ImageRepeat.repeat,
                      opacity: 0.1,
                    ),
                  ),
                ),

              // Main display area
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

              // Controls overlay
              if (_showControls) _buildControlsOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  String _getLEDPatternSVG() {
    return '''
    <svg width="20" height="20" xmlns="http://www.w3.org/2000/svg">
      <circle cx="10" cy="10" r="1" fill="white" opacity="0.3"/>
    </svg>
    ''';
  }

  bool _isVerticalScroll() {
    final direction = bannerConfig['scrollDirection'] as String;
    return direction == 'up' || direction == 'down';
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _fadeController?.dispose();
    _glowController?.dispose();
    _bounceController?.dispose();
    _controlsTimer?.cancel();
    _flashTimer?.cancel();
    _hideTimer?.cancel();

    // Restore portrait + UI mode just in case
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
