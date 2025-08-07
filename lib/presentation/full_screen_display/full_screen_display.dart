// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sizer/sizer.dart';

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
//   AnimationController? _glowController;
//   AnimationController? _bounceController;
//   Animation<double>? _scrollAnimation;
//   Animation<double>? _fadeAnimation;
//   Animation<double>? _glowAnimation;
//   Animation<double>? _bounceAnimation;

//   Map<String, dynamic> bannerConfig = {
//     'text': 'LED BANNER DISPLAY',
//     'scrollDirection': 'left_to_right',
//     'scrollSpeed': 50.0,
//     'textColor': '#FF0000',
//     'backgroundColor': '#000000',
//     'fontSize': 24.0,
//     'isFlashing': false,
//     'soundEnabled': false,
//     'fontStyle': 'dot-matrix',
//   };

//   bool _isPlaying = true;
//   bool _showControls = false;
//   bool _isMaxBrightness = false;
//   Timer? _controlsTimer;
//   Timer? _flashTimer;
//   Timer? _hideTimer;
//   bool _flashVisible = true;
//   int _tapCount = 0;

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
//     _startHideTimer();
//   }

//   void _setupAnimations() {
//     // Dispose existing controllers first
//     _scrollController?.dispose();
//     _fadeController?.dispose();
//     _glowController?.dispose();
//     _bounceController?.dispose();

//     final duration = Duration(
//       milliseconds: (8000 / (bannerConfig['scrollSpeed'] as double)).round(),
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
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController!,
//       curve: Curves.easeInOut,
//     ));

//     // Glow effect animation
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _glowAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _glowController!,
//       curve: Curves.easeInOut,
//     ));

//     // Bounce effect for interactions
//     _bounceController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     _bounceAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(CurvedAnimation(
//       parent: _bounceController!,
//       curve: Curves.elasticOut,
//     ));

//     if (_isPlaying) {
//       _startScrolling();
//     }

//     if (bannerConfig['isFlashing'] as bool) {
//       _setupFlashing();
//     }

//     _glowController?.repeat(reverse: true);
//   }

//   double _getScrollStartPosition() {
//     switch (bannerConfig['scrollDirection']) {
//       case 'left_to_right':
//         return -150.w;
//       case 'right_to_left':
//         return 150.w;
//       case 'up':
//         return 150.h;
//       case 'down':
//         return -150.h;
//       default:
//         return -150.w;
//     }
//   }

//   double _getScrollEndPosition() {
//     switch (bannerConfig['scrollDirection']) {
//       case 'left_to_right':
//         return 150.w;
//       case 'right_to_left':
//         return -150.w;
//       case 'up':
//         return -150.h;
//       case 'down':
//         return 150.h;
//       default:
//         return 150.w;
//     }
//   }

//   void _startScrolling() {
//     _scrollController?.repeat();
//   }

//   void _setupFlashing() {
//     _flashTimer?.cancel();
//     _flashTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
//       if (mounted) {
//         setState(() {
//           _flashVisible = !_flashVisible;
//         });
//       }
//     });
//   }

//   void _startHideTimer() {
//     _hideTimer?.cancel();
//     _hideTimer = Timer(const Duration(seconds: 5), () {
//       if (mounted && _showControls) {
//         _hideControlsOverlay();
//       }
//     });
//   }

//   void _enterFullScreen() {
//     // Set landscape orientation
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: Colors.transparent,
//       statusBarBrightness:
//           _isMaxBrightness ? Brightness.light : Brightness.dark,
//     ));
//   }

//   void _exitFullScreen() async {
//     // Show exit animation
//     _bounceController?.forward().then((_) async {
//       // 1. Set back to portrait orientation
//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);

//       // 2. Restore system UI
//       await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//       // 3. Wait a moment for orientation change to take effect
//       await Future.delayed(const Duration(milliseconds: 300));

//       // 4. Now safely pop the screen
//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     });
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
//     _bounceController?.forward().then((_) => _bounceController?.reverse());
//   }

//   void _toggleBrightness() {
//     setState(() {
//       _isMaxBrightness = !_isMaxBrightness;
//     });

//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarBrightness:
//           _isMaxBrightness ? Brightness.light : Brightness.dark,
//       statusBarColor: Colors.transparent,
//       systemNavigationBarColor: Colors.transparent,
//     ));

//     _hideControlsAfterDelay();
//     _bounceController?.forward().then((_) => _bounceController?.reverse());
//   }

//   void _showControlsOverlay() {
//     setState(() {
//       _showControls = true;
//     });
//     _fadeController?.forward();
//     _hideControlsAfterDelay();
//   }

//   void _hideControlsOverlay() {
//     _fadeController?.reverse().then((_) {
//       if (mounted) {
//         setState(() {
//           _showControls = false;
//         });
//       }
//     });
//   }

//   void _hideControlsAfterDelay() {
//     _controlsTimer?.cancel();
//     _controlsTimer = Timer(const Duration(seconds: 4), () {
//       if (mounted) {
//         _hideControlsOverlay();
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
//     final fontStyle = bannerConfig['fontStyle'] as String? ?? 'dot-matrix';

//     return AnimatedBuilder(
//       animation: _glowAnimation!,
//       builder: (context, child) {
//         return AnimatedBuilder(
//           animation: _bounceAnimation!,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _bounceAnimation!.value,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     // Dynamic glow effect
//                     BoxShadow(
//                       color: textColor
//                           .withOpacity(0.3 + (_glowAnimation!.value * 0.4)),
//                       blurRadius: 20 + (_glowAnimation!.value * 15),
//                       spreadRadius: 2 + (_glowAnimation!.value * 3),
//                       offset: const Offset(0, 0),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   text,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontWeight: fontStyle == 'segment'
//                         ? FontWeight.w900
//                         : FontWeight.bold,
//                     color: isFlashing
//                         ? (_flashVisible
//                             ? textColor
//                             : textColor.withOpacity(0.3))
//                         : textColor,
//                     fontFamily:
//                         fontStyle == 'segment' ? 'Courier' : 'monospace',
//                     letterSpacing: fontStyle == 'segment' ? 4.0 : 2.0,
//                     height: 1.2,
//                     shadows: [
//                       // Inner glow
//                       Shadow(
//                         color: textColor.withOpacity(0.8),
//                         blurRadius: 5.0,
//                         offset: const Offset(0, 0),
//                       ),
//                       // Outer glow
//                       Shadow(
//                         color: textColor.withOpacity(0.4),
//                         blurRadius: 15.0,
//                         offset: const Offset(0, 0),
//                       ),
//                       // Far glow
//                       Shadow(
//                         color: textColor.withOpacity(0.2),
//                         blurRadius: 30.0,
//                         offset: const Offset(0, 0),
//                       ),
//                       // Directional shadow for depth
//                       Shadow(
//                         color: Colors.black.withOpacity(0.5),
//                         blurRadius: 8.0,
//                         offset: const Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
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
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.black.withOpacity(0.7),
//                   Colors.black.withOpacity(0.9),
//                   Colors.black.withOpacity(0.7),
//                 ],
//               ),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.2),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Main play/pause button
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: _isPlaying
//                                 ? [Colors.orange[400]!, Colors.red[400]!]
//                                 : [Colors.green[400]!, Colors.teal[400]!],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: (_isPlaying ? Colors.orange : Colors.green)
//                                   .withOpacity(0.4),
//                               blurRadius: 20,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(50),
//                             onTap: _togglePlayPause,
//                             child: Container(
//                               width: 100,
//                               height: 100,
//                               child: Icon(
//                                 _isPlaying
//                                     ? Icons.pause_rounded
//                                     : Icons.play_arrow_rounded,
//                                 color: Colors.white,
//                                 size: 50,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 6.h),

//                       // Control buttons row
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 8.w, vertical: 3.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.2),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Brightness toggle
//                             _buildControlButton(
//                               icon: _isMaxBrightness
//                                   ? Icons.brightness_high_rounded
//                                   : Icons.brightness_medium_rounded,
//                               label: 'Brightness',
//                               isActive: _isMaxBrightness,
//                               activeColor: Colors.amber,
//                               onPressed: _toggleBrightness,
//                             ),

//                             SizedBox(width: 8.w),

//                             // Speed indicator
//                             _buildInfoChip(
//                                 '${bannerConfig['scrollSpeed']}x Speed'),

//                             SizedBox(width: 8.w),

//                             // Exit button
//                             _buildControlButton(
//                               icon: Icons.close_rounded,
//                               label: 'Exit',
//                               isActive: false,
//                               activeColor: Colors.red,
//                               onPressed: _exitFullScreen,
//                             ),
//                           ],
//                         ),
//                       ),

//                       SizedBox(height: 4.h),

//                       // Gesture hints
//                       Container(
//                         padding: EdgeInsets.all(3.w),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text(
//                           'Tap to show controls • Double tap for brightness • Swipe to exit',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required bool isActive,
//     required Color activeColor,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(15),
//         onTap: onPressed,
//         child: Container(
//           padding: EdgeInsets.all(3.w),
//           decoration: BoxDecoration(
//             color: isActive
//                 ? activeColor.withOpacity(0.2)
//                 : Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(15),
//             border: isActive
//                 ? Border.all(color: activeColor.withOpacity(0.5))
//                 : null,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 color: isActive ? activeColor : Colors.white,
//                 size: 24,
//               ),
//               SizedBox(height: 1.h),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isActive ? activeColor : Colors.white.withOpacity(0.8),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoChip(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.blue[200],
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   void _handleTap() {
//     _tapCount++;

//     if (_tapCount == 1) {
//       // Single tap - show/hide controls
//       if (_showControls) {
//         _hideControlsOverlay();
//       } else {
//         _showControlsOverlay();
//       }

//       // Reset tap count after delay
//       Timer(const Duration(milliseconds: 300), () {
//         _tapCount = 0;
//       });
//     } else if (_tapCount == 2) {
//       // Double tap - toggle brightness
//       _toggleBrightness();
//       _tapCount = 0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     final backgroundColor = _getBackgroundColor();

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: GestureDetector(
//         onTap: _handleTap,
//         onVerticalDragEnd: (details) {
//           if (details.primaryVelocity != null &&
//               details.primaryVelocity! < -800) {
//             _exitFullScreen();
//           }
//         },
//         onHorizontalDragEnd: (details) {
//           if (details.primaryVelocity != null &&
//               details.primaryVelocity!.abs() > 800) {
//             _exitFullScreen();
//           }
//         },
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: RadialGradient(
//               center: Alignment.center,
//               radius: 1.2,
//               colors: [
//                 backgroundColor.withOpacity(0.8),
//                 backgroundColor,
//                 Colors.black,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               // Background pattern (subtle LED grid effect)
//               // if (!_isMaxBrightness)
//               //   Container(
//               //     width: double.infinity,
//               //     height: double.infinity,
//               //     decoration: BoxDecoration(
//               //       image: DecorationImage(
//               //         image: NetworkImage(
//               //             'data:image/svg+xml,${Uri.encodeComponent(_getLEDPatternSVG())}'),
//               //         repeat: ImageRepeat.repeat,
//               //         opacity: 0.1,
//               //       ),
//               //     ),
//               //   ),
//               if (!_isMaxBrightness)
//                 Positioned.fill(
//                   child: IgnorePointer(
//                     child: Opacity(
//                       opacity: 0.1,
//                       child: SvgPicture.asset(
//                         'assets/images/led_pattern.svg',
//                         fit: BoxFit.cover,
//                         alignment: Alignment.center,
//                         // Note: no repeat here, SVG won't repeat automatically
//                       ),
//                     ),
//                   ),
//                 ),

//               // Main display area
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

//               // Controls overlay
//               if (_showControls) _buildControlsOverlay(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getLEDPatternSVG() {
//     return '''
//     <svg width="20" height="20" xmlns="http://www.w3.org/2000/svg">
//       <circle cx="10" cy="10" r="1" fill="white" opacity="0.3"/>
//     </svg>
//   ''';
//   }

//   bool _isVerticalScroll() {
//     final direction = bannerConfig['scrollDirection'] as String;
//     return direction == 'up' || direction == 'down';
//   }

//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     _fadeController?.dispose();
//     _glowController?.dispose();
//     _bounceController?.dispose();
//     _controlsTimer?.cancel();
//     _flashTimer?.cancel();
//     _hideTimer?.cancel();

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
    'isGlowing': true,
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

    if (bannerConfig['isFlashing'] as bool && _isPlaying) {
      _setupFlashing();
    }

    if (bannerConfig['isGlowing'] as bool && _isPlaying) {
      _glowController?.repeat(reverse: true);
    }
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
    if (_isPlaying) {
      _flashTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
        if (mounted) {
          setState(() {
            _flashVisible = !_flashVisible;
          });
        }
      });
    }
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
    _bounceController?.forward().then((_) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      await Future.delayed(const Duration(milliseconds: 300));

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
      if (bannerConfig['isFlashing'] as bool) {
        _setupFlashing();
      }
      if (bannerConfig['isGlowing'] as bool) {
        _glowController?.repeat(reverse: true);
      }
    } else {
      _scrollController?.stop();
      _flashTimer?.cancel();
      _glowController?.stop();
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
    final isGlowing = bannerConfig['isGlowing'] as bool;
    final fontStyle = bannerConfig['fontStyle'] as String? ?? 'dot-matrix';

    return AnimatedBuilder(
      animation: isGlowing ? _glowAnimation! : AlwaysStoppedAnimation(0.0),
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
                  boxShadow: isGlowing
                      ? [
                          BoxShadow(
                            color: textColor.withOpacity(
                                0.3 + (_glowAnimation!.value * 0.4)),
                            blurRadius: 20 + (_glowAnimation!.value * 15),
                            spreadRadius: 2 + (_glowAnimation!.value * 3),
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: textColor.withOpacity(0.8),
                            blurRadius: 5.0,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: textColor.withOpacity(0.4),
                            blurRadius: 15.0,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: textColor.withOpacity(0.2),
                            blurRadius: 30.0,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8.0,
                            offset: const Offset(2, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8.0,
                            offset: const Offset(2, 2),
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
          child: RepaintBoundary(
            child: _buildLEDText(),
          ),
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
                            _buildInfoChip(
                                '${bannerConfig['scrollSpeed']}x Speed'),
                            SizedBox(width: 8.w),
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
      if (_showControls) {
        _hideControlsOverlay();
      } else {
        _showControlsOverlay();
      }
      Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
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
              if (!_isMaxBrightness)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.1,
                      child: CustomPaint(
                        painter: LEDPatternPainter(),
                        child: Container(),
                      ),
                    ),
                  ),
                ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection:
                          _isVerticalScroll() ? Axis.vertical : Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: RepaintBoundary(
                        child: _buildScrollingText(),
                      ),
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
    _glowController?.dispose();
    _bounceController?.dispose();
    _controlsTimer?.cancel();
    _flashTimer?.cancel();
    _hideTimer?.cancel();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}

class LEDPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x + 10, y + 10), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
