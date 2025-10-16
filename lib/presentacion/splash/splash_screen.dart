import 'package:app/presentacion/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_paths.dart';
import '../../core/utils/delay.dart';
import '../../core/utils/nav_helper.dart';
import '../widgets/reflective_background.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateNext();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _opacity = 1.0);
  }

  Future<void> _navigateNext() async {
    await delay(4000);
    if (mounted) {
      NavHelper.navigateAndReplace(context, const SignupScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: ReflectiveBackground(
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: _opacity,
            curve: Curves.easeInOut,
            child: Image.asset(AppPaths.logoBlanco, width: 600),
          ),
        ),
      ),
    );
  }
}
