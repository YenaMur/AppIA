import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/rutas/app_rutas.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ContaIA',
      theme: AppTheme.lightTheme,
      initialRoute: AppRutas.splash,
      routes: AppRutas.rutas,
    );
  }
}
