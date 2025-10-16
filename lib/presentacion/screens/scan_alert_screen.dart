import 'package:app/presentacion/home/home_screen.dart';
import 'package:app/presentacion/screens/camera_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import '../../core/constants/app_texts.dart';
import '../../core/utils/nav_helper.dart';

class ScanAlertScreen extends StatelessWidget {
  const ScanAlertScreen({super.key});

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
          padding: const EdgeInsets.only(left: 24, top: 24), // margen exacto
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              NavHelper.navigateAndReplace(context, const HomeScreen());
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // alinea a la izquierda
          children: [
            // Título principal
            const Text(
              "Escanea tu factura",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Subtítulo
            const Text(
              "Escanea tu factura y deja que ContaIA clasifique\nla información por ti.",
              textAlign: TextAlign.left, // texto alineado a la izquierda
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Ícono de cámara dentro del círculo
            Center(
              child: SizedBox(
                width: 600,
                height: 600,
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    // Círculo de fondo
                    Image(
                      image: AssetImage(
                        'assets/images/fluent_scan-camera-48-regular.png',
                      ),
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    Image(
                      image: AssetImage('assets/images/Ellipse 2.png'),
                      width: 600,
                      height: 600,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Botón principal
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  NavHelper.navigateTo(context, const CameraPreviewScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  AppTexts.scanButton,
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
