import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _glowAnimationController;
  late AnimationController _loadingAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _loadingAnimation;

  String _loadingText = 'Initializing LED Engine...';
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Glow animation controller
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Glow animation
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading progress animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _glowAnimationController.repeat(reverse: true);
    _loadingAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    // Hide system UI for full LED aesthetic
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Simulate initialization steps with real-like timing
    await _initializeStep('Loading saved presets...', 0.2);
    await _initializeStep('Initializing font engine...', 0.4);
    await _initializeStep('Preparing LED graphics...', 0.6);
    await _initializeStep('Checking permissions...', 0.8);
    await _initializeStep('Ready to create banners!', 1.0);

    setState(() {
    });

    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate to banner creator
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/banner-creator');
    }
  }

  Future<void> _initializeStep(String text, double progress) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _loadingText = text;
        _loadingProgress = progress;
      });
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _glowAnimationController.dispose();
    _loadingAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundDark,
              AppTheme.backgroundDark.withValues(alpha: 0.8),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // LED Logo with glow effect
              AnimatedBuilder(
                animation: Listenable.merge([
                  _logoAnimationController,
                  _glowAnimationController,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.ledBlue.withValues(
                                  alpha: _glowAnimation.value * 0.6),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: AppTheme.ledGreen.withValues(
                                  alpha: _glowAnimation.value * 0.4),
                              blurRadius: 50,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: _buildLEDLogo(),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),

              // App Title with LED effect
              AnimatedBuilder(
                animation: _logoOpacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Text(
                      'LED BANNER',
                      style:
                          AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                        color: AppTheme.ledBlue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        shadows: [
                          Shadow(
                            color: AppTheme.ledBlue.withValues(alpha: 0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 1.h),

              // Subtitle
              AnimatedBuilder(
                animation: _logoOpacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value * 0.8,
                    child: Text(
                      'DISPLAY',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisDark,
                        letterSpacing: 2.0,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),

              // Loading section
              AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _loadingAnimation.value,
                    child: Column(
                      children: [
                        // Loading text
                        Text(
                          _loadingText,
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textMediumEmphasisDark,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Loading progress bar
                        Container(
                          width: 60.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.textDisabledDark
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 60.w * _loadingProgress,
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.ledBlue,
                                  AppTheme.ledGreen,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.ledBlue.withValues(alpha: 0.5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Loading percentage
                        Text(
                          '${(_loadingProgress * 100).toInt()}%',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textDisabledDark,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLEDLogo() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.backgroundDark,
            Colors.black,
          ],
        ),
        border: Border.all(
          color: AppTheme.ledBlue.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _glowAnimationController,
          builder: (context, child) {
            return CustomPaint(
              size: Size(25.w, 25.w),
              painter: LEDLogoPainter(
                glowIntensity: _glowAnimation.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class LEDLogoPainter extends CustomPainter {
  final double glowIntensity;

  LEDLogoPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final dotRadius = size.width * 0.02;
    final spacing = size.width * 0.08;

    // Create LED dot matrix pattern for "LED" text
    final ledPattern = [
      // L
      [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [1, 4], [2, 4],
      // E
      [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [5, 0], [5, 2], [5, 4], [6, 0],
      [6, 2], [6, 4],
      // D
      [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [9, 0], [9, 4], [10, 1], [10, 2],
      [10, 3],
    ];

    // Calculate starting position to center the pattern
    final startX = center.dx - (10 * spacing) / 2;
    final startY = center.dy - (4 * spacing) / 2;

    // Draw LED dots
    for (final dot in ledPattern) {
      final x = startX + (dot[0] * spacing);
      final y = startY + (dot[1] * spacing);

      // Glow effect
      paint.color = AppTheme.ledBlue.withValues(alpha: glowIntensity * 0.3);
      canvas.drawCircle(Offset(x, y), dotRadius * 2, paint);

      // Main dot
      paint.color = AppTheme.ledBlue.withValues(alpha: glowIntensity);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);

      // Bright center
      paint.color = Colors.white.withValues(alpha: glowIntensity * 0.8);
      canvas.drawCircle(Offset(x, y), dotRadius * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is LEDLogoPainter &&
        oldDelegate.glowIntensity != glowIntensity;
  }
}
