import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'Login_Users_Screen.dart';
import 'Onboarding/onboarding_screen1.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final String logoPath;
  final Duration duration;
  final Color backgroundColor;

  const SplashScreen({
    Key? key,
    required this.logoPath,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor = Colors.white, required nextScreen,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateAfterDelay();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  /// الانتقال بعد انتهاء المدة المحددة مع التحقق من حالة Onboarding و Login
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(widget.duration);

    if (!mounted) return;

    // التحقق من شاشة الترحيب
    final isOnboardingShown = _storage.read('isOnboardingShown') ?? false;
    // التحقق من تسجيل الدخول
    final isLoggedIn = _storage.read('isLoggedIn') ?? false;

    Widget nextScreen;

    if (!isOnboardingShown) {
      nextScreen = OnboardingScreen();
    } else if (!isLoggedIn) {
      nextScreen = LoginScreen();
    } else {
      nextScreen = HomeScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            widget.logoPath,
            height: 270,
          ),
        ),
      ),
    );
  }
}
