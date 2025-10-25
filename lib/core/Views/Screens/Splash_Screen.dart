import 'package:flutter/material.dart';

/// شاشة البداية (Splash Screen)
/// تظهر الشعار مع حركة تكبير تدريجية وتنتقل تلقائيًا إلى الشاشة التالية.
class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final String logoPath;
  final Duration duration;
  final Color backgroundColor;

  const SplashScreen({
    Key? key,
    required this.nextScreen,
    required this.logoPath,
    this.duration = const Duration(seconds: 5),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// الحالة الخاصة بـ SplashScreen
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateAfterDelay();
  }

  /// تهيئة الأنميشن (تكبير + تلاشي تدريجي)
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

  /// الانتقال بعد انتهاء المدة المحددة
  void _navigateAfterDelay() {
    Future.delayed(widget.duration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// بناء واجهة المستخدم
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
          child: _buildLogo(),
        ),
      ),
    );
  }

  /// ودجت الشعار (منفصلة لسهولة التعديل)
  Widget _buildLogo() {
    return Image.asset(
      widget.logoPath,
      height: 270,

    );
  }
}
