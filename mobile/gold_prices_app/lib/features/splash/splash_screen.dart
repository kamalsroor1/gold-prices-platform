import 'package:flutter/material.dart';
import '../../core/local_storage_service.dart';
import '../navigation/main_navigation_screen.dart';
import '../auth/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // التحقق من الجلسة والانتقال بعد انتهاء الـ Splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final String? savedToken = LocalStorageService.token;
        
        // إذا كان هناك توكين محفوظ محلياً، يدخل فوراً دون الحاجة لتسجيل دخول مجدداً عند الـ Refresh!
        if (savedToken != null && savedToken.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen(countryId: 1)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond_outlined, size: 100, color: Color(0xFF00BFA5)),
              const SizedBox(height: 20),
              const Text(
                'Gold Prices',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(color: Color(0xFF00BFA5), strokeWidth: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
