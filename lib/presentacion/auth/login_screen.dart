import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_texts.dart';
import 'package:app/core/utils/nav_helper.dart';
import 'package:app/core/utils/validator.dart';
import 'package:app/presentacion/auth/login_phone_screen.dart';
import 'package:app/presentacion/auth/register_screen.dart';
import 'package:app/presentacion/auth/signup_screen.dart';
import 'package:app/presentacion/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_paths.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isEmailSelected = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      NavHelper.navigateAndReplace(context, const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Contenido principal con scroll
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Botón atrás
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => NavHelper.navigateAndReplace(
                            context,
                            SignupScreen(),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.buttonSecondary,
                            foregroundColor: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Título principal
                      const Text(
                        AppTexts.welcomeBack,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      const Text(
                        AppTexts.loginSubtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Selector Email / Número
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              child: const Text(AppTexts.email),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                NavHelper.navigateAndReplace(
                                  context,
                                  const LoginWithPhoneScreen(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonSecondary,
                                foregroundColor: AppColors.textPrimary,

                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.835,
                                ),
                              ),
                              child: const Text(AppTexts.phone),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 64),

                      // Formulario
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: AppTexts.email,
                                hintText: AppTexts.hintEmail,
                              ),
                              validator: Validator.validateEmail,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: AppTexts.password,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  }),
                                ),
                              ),
                              validator: Validator.validatePassword,
                            ),
                            //const SizedBox(height: 1),

                            // Olvidé contraseña
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  AppTexts.forgotPassword,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Botón principal
                            ElevatedButton(
                              onPressed: _login,
                              child: const Text(
                                AppTexts.loginAccess,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Center(
                              child: Text(
                                AppTexts.continueWith,
                                style: TextStyle(color: AppColors.textHint),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botones Google / Apple
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                AppPaths.iconoGoogle,
                                width: 24,
                                height: 24,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                              ),
                              label: const Text(
                                AppTexts.loginWithGoogle,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 16),

                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 40,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                              ),
                              label: const Text(
                                AppTexts.loginWithApple,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Texto inferior fijo (64 px del borde)
              Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppTexts.noAccount),
                    TextButton(
                      onPressed: () {
                        NavHelper.navigateAndReplace(
                          context,
                          const RegisterScreen(),
                        );
                      },
                      child: const Text(AppTexts.registerNow),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
