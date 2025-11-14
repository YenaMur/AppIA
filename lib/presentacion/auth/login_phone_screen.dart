import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_texts.dart';
import 'package:app/core/constants/app_paths.dart';
import 'package:app/core/utils/nav_helper.dart';
import 'package:app/core/utils/validator.dart';
import 'package:app/presentacion/auth/login_screen.dart';
import 'package:app/presentacion/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../home/home_screen.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({super.key});

  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      NavHelper.navigateAndReplace(context, const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo reducido
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.012),

                // Botón atrás
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () =>
                        NavHelper.navigateAndReplace(context, LoginScreen()),
                    iconSize: (screenHeight * 0.020) * scaleFactor,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      foregroundColor: AppColors.textSecondary,
                      padding: EdgeInsets.all(screenWidth * 0.02),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.012),

                // Título principal
                Text(
                  AppTexts.welcomeBack,
                  style: TextStyle(
                    fontSize: (screenHeight * 0.032) * scaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),

                Text(
                  AppTexts.loginSubtitle,
                  style: TextStyle(
                    fontSize: (screenHeight * 0.012) * scaleFactor,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Selector Correo / Celular - CENTRADO
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.38,
                        child: ElevatedButton(
                          onPressed: () {
                            NavHelper.navigateAndReplace(
                              context,
                              const LoginScreen(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonSecondary,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.010,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: (screenHeight * 0.015) * scaleFactor,
                            ),
                          ),
                          child: const Text('Correo'),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      SizedBox(
                        width: screenWidth * 0.38,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.010,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: (screenHeight * 0.015) * scaleFactor,
                            ),
                          ),
                          child: const Text('Celular'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.028),

                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Campo teléfono
                      IntlPhoneField(
                        flagsButtonPadding: EdgeInsets.only(
                          left: screenWidth * 0.02,
                        ),
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: AppTexts.phone,
                          hintText: AppTexts.enterPhone,
                          labelStyle: TextStyle(
                            fontSize: (screenHeight * 0.015) * scaleFactor,
                          ),
                          hintStyle: TextStyle(
                            fontSize: (screenHeight * 0.015) * scaleFactor,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        initialCountryCode: 'CO',
                        dropdownIconPosition: IconPosition.trailing,
                        disableLengthCheck: true,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: (screenHeight * 0.016) * scaleFactor,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (phone) {
                          debugPrint(
                            'Número completo: ${phone.completeNumber}',
                          );
                        },
                        onCountryChanged: (country) {
                          debugPrint('País seleccionado: ${country.name}');
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return 'Por favor ingresa tu número de teléfono.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(
                          fontSize: (screenHeight * 0.016) * scaleFactor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppTexts.password,
                          labelStyle: TextStyle(
                            fontSize: (screenHeight * 0.015) * scaleFactor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: (screenHeight * 0.023) * scaleFactor,
                            ),
                            onPressed: () => setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            }),
                          ),
                        ),
                        validator: Validator.validatePassword,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.006,
                            ),
                          ),
                          child: Text(
                            AppTexts.forgotPassword,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: (screenHeight * 0.014) * scaleFactor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.012),

                      // Botón principal
                      SizedBox(
                        height: screenHeight * 0.055,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            AppTexts.loginAccess,
                            style: TextStyle(
                              fontSize: (screenHeight * 0.016) * scaleFactor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      Center(
                        child: Text(
                          AppTexts.continueWith,
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: (screenHeight * 0.014) * scaleFactor,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      // Botones Google / Apple
                      SizedBox(
                        height: screenHeight * 0.055,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            AppPaths.iconoGoogle,
                            width: (screenHeight * 0.026) * scaleFactor,
                            height: (screenHeight * 0.026) * scaleFactor,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black,
                          ),
                          label: Text(
                            AppTexts.loginWithGoogle,
                            style: TextStyle(
                              fontSize: (screenHeight * 0.015) * scaleFactor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.012),

                      SizedBox(
                        height: screenHeight * 0.055,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.apple,
                            color: Colors.black,
                            size: (screenHeight * 0.032) * scaleFactor,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black,
                          ),
                          label: Text(
                            AppTexts.loginWithApple,
                            style: TextStyle(
                              fontSize: (screenHeight * 0.015) * scaleFactor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Texto inferior
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppTexts.noAccount,
                            style: TextStyle(
                              fontSize: (screenHeight * 0.015) * scaleFactor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              NavHelper.navigateAndReplace(
                                context,
                                const RegisterScreen(),
                              );
                            },
                            child: Text(
                              AppTexts.registerNow,
                              style: TextStyle(
                                fontSize: (screenHeight * 0.015) * scaleFactor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.025),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
