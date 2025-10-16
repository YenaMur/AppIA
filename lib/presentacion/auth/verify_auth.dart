import 'dart:async';
import 'package:flutter/material.dart';
import '/core/constants/app_texts.dart';
import '/core/constants/app_colors.dart';
import '/core/constants/app_values.dart';
import '/core/rutas/app_rutas.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  int _remainingSeconds = 24;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onVerify() {
    final code = _codeControllers.map((c) => c.text).join();
    if (code.length == 4) {
      Navigator.pushNamed(context, AppRutas.verify);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa los 4 dígitos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppValues.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              AppTexts.verifyTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppTexts.verifySubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Cajas del código
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _codeControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Contador de reenvío
            RichText(
              text: TextSpan(
                text: '${AppTexts.verifyResend} ',
                style: const TextStyle(color: AppColors.textSecondary),
                children: [
                  TextSpan(
                    text: '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón verificar
            ElevatedButton(
              onPressed: _onVerify,
              child: const Text(AppTexts.verifyButton),
            ),
          ],
        ),
      ),
    );
  }
}
