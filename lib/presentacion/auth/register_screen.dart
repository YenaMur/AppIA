import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/core/constants/app_texts.dart';
import '/core/constants/app_values.dart';
import '/core/constants/app_colors.dart';
import '/core/utils/validator.dart';
import '/core/rutas/app_rutas.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.07),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.02),

                // Título principal
                Text(
                  AppTexts.registerButton,
                  style: TextStyle(
                    fontSize: w * 0.08,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.008),

                Text(
                  'Únete hoy y desbloquea todas las posibilidades.\nEs rápido, fácil y solo te tomará un instante.',
                  style: TextStyle(
                    fontSize: w * 0.035,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: h * 0.03),

                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nombre
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo *',
                          border: OutlineInputBorder(),
                        ),
                        validator: Validator.validateName,
                      ),
                      SizedBox(height: h * 0.018),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico *',
                          border: OutlineInputBorder(),
                        ),
                        validator: Validator.validateEmail,
                      ),
                      SizedBox(height: h * 0.018),

                      // Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña *',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textHint,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: Validator.validatePassword,
                      ),
                      SizedBox(height: h * 0.01),

                      Text(
                        AppTexts.hintPassword,
                        style: TextStyle(
                          fontSize: w * 0.03,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: h * 0.018),

                      // Confirmar contraseña
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña *',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textHint,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return AppTexts.errorPasswordMatch;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: h * 0.018),

                      // Celular
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Número de celular',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            Validator.validateNotEmpty(value, 'celular'),
                      ),
                      SizedBox(height: h * 0.018),

                      // Términos y condiciones
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Al crear una cuenta, aceptas nuestros ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: w * 0.032,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Términos y Condiciones',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  const TextSpan(text: ' y nuestro '),
                                  TextSpan(
                                    text: 'Aviso de Privacidad.',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.03),

                      // Botón Crear cuenta
                      SizedBox(
                        width: double.infinity,
                        height: h * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _acceptTerms) {
                              Navigator.pushNamed(context, AppRutas.verify);
                            } else if (!_acceptTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Debes aceptar los Términos y Condiciones.',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(h * 0.015),
                            ),
                            backgroundColor: AppColors.primary,
                            textStyle: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text(AppTexts.registerButton),
                        ),
                      ),
                      SizedBox(height: h * 0.025),

                      // Ya tienes cuenta
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: '${AppTexts.alreadyHaveAccount} ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: w * 0.035,
                            ),
                            children: [
                              TextSpan(
                                text: AppTexts.loginButton,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                    context,
                                    AppRutas.login,
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.05),
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
