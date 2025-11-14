import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/core/services/ocr_service.dart';

class TestOCRScreen extends StatefulWidget {
  const TestOCRScreen({super.key});

  @override
  State<TestOCRScreen> createState() => _TestOCRScreenState();
}

class _TestOCRScreenState extends State<TestOCRScreen> {
  String resultado = "Esperando OCR...";
  final OCRService _ocr = OCRService();

  Future<void> _probarOCR() async {
    try {
      print("🔹 Cargando imagen desde assets...");
      final ByteData data = await rootBundle.load(
        'assets/images/Factura_prueba.png',
      );

      print("🔹 Guardando imagen temporal...");
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/Factura_prueba.png';
      final file = await File(tempPath).writeAsBytes(data.buffer.asUint8List());

      print("🔹 Iniciando OCR...");
      final dataOCR = await _ocr.procesarImagen(file);
      print("✅ OCR finalizado.");

      setState(() {
        resultado =
            """
📄 TEXTO DETECTADO:
${dataOCR["texto"] ?? "No se detectó texto"}

🏷 PROVEEDOR: ${dataOCR["proveedor"]}
💰 MONTO: ${dataOCR["monto"]}
📅 FECHA: ${dataOCR["fecha"]}
""";
      });
    } catch (e) {
      setState(() {
        resultado = "❌ Error: $e";
      });
      print("❌ Error completo: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _probarOCR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test OCR")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: Text(resultado)),
      ),
    );
  }
}
