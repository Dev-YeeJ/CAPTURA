import 'package:flutter/material.dart';
// Import your next screen here
import 'obs_one.dart';

class SplashScreenSecond extends StatefulWidget {
  const SplashScreenSecond({super.key});

  @override
  State<SplashScreenSecond> createState() => _SplashScreenSecondState();
}

class _SplashScreenSecondState extends State<SplashScreenSecond>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo fade-in animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Text slide-in animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text slide animation (from left to right)
    _textSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Text fade animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Start animations sequentially
    _startAnimations();

    // Navigate to obs_one screen after all animations
    Future.delayed(const Duration(milliseconds: 2500), () {
      _navigateToObsOne();
    });
  }

  void _startAnimations() async {
    // Start logo fade-in first
    await _logoController.forward();
    // Then start text slide-in with a small delay
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
  }

  void _navigateToObsOne() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ObsOne(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C1C2E), // Blue-800
              Color(0xFF1A4D9C), // Blue-700
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo with fade-in animation
              AnimatedBuilder(
                animation: _logoFadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Center(
                      child: Image.asset(
                        'assets/images/captura.png', // Add your logo image to assets folder
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // CAPTURA text image with slide-in animation - MADE BIGGER
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_textSlideAnimation.value, 0),
                    child: Opacity(
                      opacity: _textFadeAnimation.value,
                      child: Center(
                        child: Image.asset(
                          'assets/images/capturatext.png', // Add your CAPTURA text image here
                          width: 300, // Increased from 250 to 350
                          // Increased from 60 to 90
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
