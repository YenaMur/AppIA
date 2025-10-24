import 'package:app/presentacion/screens/historial_financiero_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/widgets/factura_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacturaConfirmScreen extends StatelessWidget {
  const FacturaConfirmScreen({super.key});

  Future<void> _guardarFactura(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('facturas').add({
        'titulo': 'Can Pujon',
        'monto': -91.50,
        'metodo': 'Efectivo',
        'categoria': 'Restaurantes',
        'fecha': DateTime.now(),
      });
      print("✅ Factura guardada correctamente");

      // Muestra mensaje visual
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Factura añadida a tus finanzas"),
          backgroundColor: Colors.green,
        ),
      );

      // Ir al historial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HistorialFinancieroScreen(),
        ),
      );
    } catch (e) {
      print("❌ Error al guardar factura: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar factura: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: const Text(
            "Confirmación",
            style: TextStyle(
              fontSize: 20,
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
            const SizedBox(height: 32),

            // ===== Ícono central =====
            Center(
              child: Column(
                children: const [
                  Image(
                    image: AssetImage('assets/icons/Icon Button.png'),
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "\$91.50",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Total de la factura (USD)",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ===== Detalles =====
            Expanded(
              child: ListView(
                children: const [
                  FacturaRow(label: "Factura ID", value: "001-000043"),
                  FacturaRow(label: "Proveedor", value: "Can Pujon"),
                  FacturaRow(
                    label: "Categoría",
                    value: "Restaurantes",
                    editable: true,
                  ),
                  FacturaRow(
                    label: "Método de pago",
                    value: "Efectivo",
                    editable: true,
                  ),
                  FacturaRow(label: "Fecha", value: "25/08/2015"),
                  FacturaRow(label: "Total", value: "\$91.50", editable: true),
                ],
              ),
            ),

            // ===== Botón principal =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _guardarFactura(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Añadir a mis finanzas",
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
