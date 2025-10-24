import 'package:app/core/utils/nav_helper.dart';
import 'package:app/presentacion/screens/historial_financiero_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/widgets/factura_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacturacionScreen extends StatefulWidget {
  final String id; // ID del documento Firestore
  final String titulo;
  final double monto;
  final String metodo;
  final String categoria;
  final DateTime fecha;

  const FacturacionScreen({
    super.key,
    required this.id,
    required this.titulo,
    required this.monto,
    required this.metodo,
    required this.categoria,
    required this.fecha,
  });

  @override
  State<FacturacionScreen> createState() => _FacturacionScreenState();
}

class _FacturacionScreenState extends State<FacturacionScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _montoController;
  late TextEditingController _metodoController;
  late TextEditingController _categoriaController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.titulo);
    _montoController = TextEditingController(
      text: widget.monto.toStringAsFixed(2),
    );
    _metodoController = TextEditingController(text: widget.metodo);
    _categoriaController = TextEditingController(text: widget.categoria);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _montoController.dispose();
    _metodoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('facturas')
          .doc(widget.id)
          .update({
            'titulo': _tituloController.text,
            'monto': double.tryParse(_montoController.text) ?? widget.monto,
            'metodo': _metodoController.text,
            'categoria': _categoriaController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Factura actualizada correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HistorialFinancieroScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar: $e"),
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => NavHelper.navigateAndReplace(
              context,
              HistorialFinancieroScreen(),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: const Text(
            "Editar Factura",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // ===== Monto =====
            Text(
              "\$${_montoController.text}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Total de la factura",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                children: [
                  FacturaRow(label: "Proveedor", value: widget.titulo),
                  FacturaRow(
                    label: "Categoría",
                    value: widget.categoria,
                    editable: true,
                    controller: _categoriaController,
                  ),
                  FacturaRow(
                    label: "Método de pago",
                    value: widget.metodo,
                    editable: true,
                    controller: _metodoController,
                  ),
                  FacturaRow(
                    label: "Fecha",
                    value:
                        "${widget.fecha.day}/${widget.fecha.month}/${widget.fecha.year}",
                  ),
                  FacturaRow(
                    label: "Total",
                    value: "\$${widget.monto.toStringAsFixed(2)}",
                    editable: true,
                    controller: _montoController,
                  ),
                ],
              ),
            ),

            // ===== Botón guardar =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _guardarCambios(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Guardar cambios",
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 52),
          ],
        ),
      ),
    );
  }
}
