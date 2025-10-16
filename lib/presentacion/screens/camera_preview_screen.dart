import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:app/presentacion/screens/success_screen_confirm.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_texts.dart';
import '../../core/utils/nav_helper.dart';

class CameraPreviewScreen extends StatelessWidget {
  const CameraPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, // Permite que el body ocupe todo el fondo
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar invisible
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8), // posición exacta
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              NavHelper.navigateAndReplace(context, const ScanAlertScreen());
            },
          ),
        ),
      ),

      body: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo de cámara (temporal: color o imagen)
          Positioned.fill(
            child: Container(
              color: Colors.pinkAccent.shade100, // reemplazar por cámara
            ),
          ),

          // Marco guía blanco
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 150, 48, 280),
              child: CustomPaint(painter: FramePainter()),
            ),
          ),

          // Instrucciones
          Positioned(
            bottom: 220,
            left: 48,
            right: 48,
            child: Column(
              children: const [
                Text(
                  AppTexts.cameraTitle,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppTexts.cameraSubtitle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Botones inferiores
          Positioned(
            bottom: 72,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reintentar
                IconButton(
                  icon: const Icon(
                    Icons.cameraswitch_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 40),

                // Tomar foto
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    onPressed: () {
                      NavHelper.navigateTo(context, SuccessScanConfirm());
                    },
                  ),
                ),
                const SizedBox(width: 40),

                // Flash
                IconButton(
                  icon: const Icon(
                    Icons.flash_auto_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  Dibuja las esquinas blancas del marco
class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double corner = 38;

    // Esquinas — arriba izquierda
    canvas.drawLine(Offset(0, 0), Offset(corner, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, corner), paint);

    // arriba derecha
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - corner, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // abajo izquierda
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - corner),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);

    // abajo derecha
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - corner, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - corner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
