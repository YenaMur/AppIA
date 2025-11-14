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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, // 6% del ancho
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espaciador superior flexible
              const Spacer(flex: 3),

              // Logo
              Flexible(
                flex: 2,
                child: Image.asset(
                  AppPaths.logoColor,
                  width: screenWidth * 0.6, // 60% del ancho
                  fit: BoxFit.contain,
                ),
              ),

              // Espaciador medio flexible
              const Spacer(flex: 3),

              // Botones al fondo
              Column(
                children: [
                  // Login botón
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.065, // 6.5% de la altura
                    child: ElevatedButton(
                      onPressed: () {
                        NavHelper.navigateAndReplace(
                          context,
                          const LoginScreen(),
                        );
                      },
                      child: Text(
                        AppTexts.loginButton,
                        style: TextStyle(
                          fontSize: screenHeight * 0.02, // 2% de la altura
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% de la altura
                  // Crear una cuenta botón
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.065, // 6.5% de la altura
                    child: ElevatedButton(
                      onPressed: () {
                        NavHelper.navigateAndReplace(
                          context,
                          const RegisterScreen(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonSecondary,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppTexts.registerButton,
                        style: TextStyle(
                          fontSize: screenHeight * 0.02, // 2% de la altura
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.08,
                  ), // 8% de la altura (distancia al borde inferior)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
