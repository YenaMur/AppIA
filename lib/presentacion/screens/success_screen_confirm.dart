import 'package:app/presentacion/screens/factura_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';

class SuccessScanConfirm extends StatelessWidget {
  const SuccessScanConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8, top: 24),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 56),
          child: Text(
            "Escaneo exitoso",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 81), // Subimos todo el bloque
            // Ícono azul grande
            Center(
              child: Image.asset(
                'assets/images/chulito 1.png',
                width: 300,
                // height: 220,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24), //menos espacio debajo del ícono
            // Texto principal
            const Text(
              "Factura escaneada",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),
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
                    MaterialPageRoute(
                      builder: (context) => const FacturaConfirmScreen(),
                    ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
