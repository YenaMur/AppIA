import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_texts.dart';
import 'package:app/core/services/ocr_service.dart';
import 'package:app/presentacion/screens/factura_confirm_screen.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _takePicture(BuildContext context) async {
    if (!_controller!.value.isInitialized) return;

    try {
      final file = await _controller!.takePicture();
      final ocrService = OCRService();

      // Loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final datos = await ocrService.procesarImagen(File(file.path));
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FacturaConfirmScreen(datosFactura: datos),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al tomar foto: $e")));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // ===== CÁMARA =====
            if (_isCameraInitialized)
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),

            // ===== MARCO (Overlay de referencia) =====
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.12,
                  screenHeight * 0.18,
                  screenWidth * 0.12,
                  screenHeight * 0.35,
                ),
                child: CustomPaint(
                  painter: FramePainter(screenWidth, scaleFactor),
                ),
              ),
            ),

            // ===== INSTRUCCIONES =====
            Positioned(
              bottom: screenHeight * 0.25,
              left: screenWidth * 0.08,
              right: screenWidth * 0.08,
              child: Column(
                children: [
                  Text(
                    AppTexts.cameraTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: (screenHeight * 0.017) * scaleFactor,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    AppTexts.cameraSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontFamily: 'Inter',
                      fontSize: (screenHeight * 0.015) * scaleFactor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ===== BOTÓN DE CAPTURA =====
            Positioned(
              bottom: screenHeight * 0.08,
              child: Container(
                width: (screenHeight * 0.08) * scaleFactor,
                height: (screenHeight * 0.08) * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: (screenHeight * 0.045) * scaleFactor,
                  ),
                  onPressed: () => _takePicture(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== MARCO (Esquinas del recuadro de captura) =====
class FramePainter extends CustomPainter {
  final double screenWidth;
  final double scaleFactor;

  FramePainter(this.screenWidth, this.scaleFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = (screenWidth * 0.007) * scaleFactor
      ..style = PaintingStyle.stroke;

    final corner = (screenWidth * 0.1) * scaleFactor;

    // Esquinas del marco (líneas)
    // superior izquierda
    canvas.drawLine(Offset(0, 0), Offset(corner, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, corner), paint);

    // superior derecha
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - corner, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // inferior izquierda
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - corner),
      paint,
    );
    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);

    // inferior derecha
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
