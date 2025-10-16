import 'package:flutter/material.dart';

// Importa todas tus pantallas
import '../../../presentacion/splash/splash_screen.dart';
import '../../../presentacion/auth/login_screen.dart';
import '../../../presentacion/auth/login_phone_screen.dart';
import '../../presentacion/auth/verify_auth.dart';

class AppRutas {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String loginWithPhone = '/login-phone';
  static const String verify = '/verify';

  static Map<String, WidgetBuilder> rutas = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    loginWithPhone: (context) => const LoginWithPhoneScreen(),
    verify: (context) => const VerifyScreen(),
  };
}
