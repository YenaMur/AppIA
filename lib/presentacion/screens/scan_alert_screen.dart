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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,

        // ===== APPBAR =====
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.09),
          child: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leadingWidth: screenWidth * 0.18,
            leading: Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.045,
                top: screenHeight * 0.01,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: (screenHeight * 0.032) * scaleFactor,
                ),
                onPressed: () {
                  NavHelper.navigateAndReplace(context, const HomeScreen());
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),

        // ===== BODY =====
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.065),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01),

              // ===== TÍTULO PRINCIPAL =====
              Text(
                "Escanea tu factura",
                style: TextStyle(
                  fontSize: (screenHeight * 0.034) * scaleFactor,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  height: 1.2,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // ===== SUBTÍTULO =====
              Text(
                "Escanea tu factura y deja que ContaIA clasifique la información por ti.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: (screenHeight * 0.016) * scaleFactor,
                  color: AppColors.textHint,
                  height: 1.4,
                  fontFamily: 'Inter',
                ),
              ),

              const Spacer(),

              // ===== ÍCONO CENTRAL =====
              Center(
                child: SizedBox(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Círculo luminoso de fondo
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/Ellipse 2.png',
                          width: screenWidth * 0.7,
                          height: screenWidth * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Ícono del escáner
                      Image.asset(
                        'assets/images/fluent_scan-camera-48-regular.png',
                        width: screenWidth * 0.28,
                        height: screenWidth * 0.28,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ===== BOTÓN PRINCIPAL =====
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    NavHelper.navigateTo(context, const CameraPreviewScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.blueAccent.withOpacity(0.4),
                    elevation: 4,
                  ),
                  child: Text(
                    AppTexts.scanButton,
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: (screenHeight * 0.018) * scaleFactor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
