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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.1),
          child: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: (screenHeight * 0.032) * scaleFactor,
                ),
                onPressed: () => NavHelper.navigateAndReplace(
                  context,
                  const HistorialFinancieroScreen(),
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: Text(
                "Editar Factura",
                style: TextStyle(
                  fontSize: (screenHeight * 0.022) * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),

              // ===== MONTO TOTAL =====
              Text(
                "\$${_montoController.text}",
                style: TextStyle(
                  fontSize: (screenHeight * 0.04) * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                "Total de la factura",
                style: TextStyle(
                  fontSize: (screenHeight * 0.016) * scaleFactor,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // ===== CAMPOS =====
              Expanded(
                child: ListView(
                  children: [
                    FacturaRow(
                      label: "Proveedor",
                      value: widget.titulo,
                      labelStyle: TextStyle(
                        fontSize: (screenHeight * 0.014) * scaleFactor,
                        color: AppColors.textSecondary,
                      ),
                      valueStyle: TextStyle(
                        fontSize: (screenHeight * 0.016) * scaleFactor,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    FacturaRow(
                      label: "Categoría",
                      value: widget.categoria,
                      editable: true,
                      controller: _categoriaController,
                      labelStyle: TextStyle(
                        fontSize: (screenHeight * 0.014) * scaleFactor,
                        color: AppColors.textSecondary,
                      ),
                      valueStyle: TextStyle(
                        fontSize: (screenHeight * 0.016) * scaleFactor,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    FacturaRow(
                      label: "Método de pago",
                      value: widget.metodo,
                      editable: true,
                      controller: _metodoController,
                      labelStyle: TextStyle(
                        fontSize: (screenHeight * 0.014) * scaleFactor,
                        color: AppColors.textSecondary,
                      ),
                      valueStyle: TextStyle(
                        fontSize: (screenHeight * 0.016) * scaleFactor,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    FacturaRow(
                      label: "Fecha",
                      value:
                          "${widget.fecha.day}/${widget.fecha.month}/${widget.fecha.year}",
                      labelStyle: TextStyle(
                        fontSize: (screenHeight * 0.014) * scaleFactor,
                        color: AppColors.textSecondary,
                      ),
                      valueStyle: TextStyle(
                        fontSize: (screenHeight * 0.016) * scaleFactor,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    FacturaRow(
                      label: "Total",
                      value: "\$${widget.monto.toStringAsFixed(2)}",
                      editable: true,
                      controller: _montoController,
                      labelStyle: TextStyle(
                        fontSize: (screenHeight * 0.014) * scaleFactor,
                        color: AppColors.textSecondary,
                      ),
                      valueStyle: TextStyle(
                        fontSize: (screenHeight * 0.016) * scaleFactor,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== BOTÓN GUARDAR =====
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.065,
                child: ElevatedButton(
                  onPressed: () => _guardarCambios(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Guardar cambios",
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: (screenHeight * 0.018) * scaleFactor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.07),
            ],
          ),
        ),
      ),
    );
  }
}
