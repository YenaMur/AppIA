import 'package:app/presentacion/auth/login_screen.dart';
import 'package:app/presentacion/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_paths.dart';
import '../../core/constants/app_texts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/nav_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 185,
              ), // ajuste visual superior
              child: Image.asset(AppPaths.logoColor, width: 500),
            ),

            // Botones al fondo

            // Login boton
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    NavHelper.navigateAndReplace(context, const LoginScreen());
                  },
                  child: const Text(AppTexts.loginButton),
                ),
                const SizedBox(height: 16),

                //Crear una cuenta boton
                ElevatedButton(
                  onPressed: () {
                    NavHelper.navigateAndReplace(
                      context,
                      const RegisterScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonSecondary,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0, // Sin sombra
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(AppTexts.registerButton),
                ),
                const SizedBox(height: 64), // distancia al borde inferior
              ],
            ),
          ],
        ),
      ),
    );
  }
}
