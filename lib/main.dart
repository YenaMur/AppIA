import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/rutas/app_rutas.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
