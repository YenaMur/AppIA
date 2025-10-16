import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/home/home_screen.dart';

class SuccessScanConfirm extends StatelessWidget {
  const SuccessScanConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 72,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24, top: 24),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título superior
            const Text(
              "Escaneo exitoso",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Ícono azul grande
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/chulito 1.png'),
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Texto principal
            const Text(
              "Factura escaneada",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtítulo
            const Text(
              "La información fue capturada con éxito.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Botón principal
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
