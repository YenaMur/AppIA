import 'package:app/presentacion/screens/historial_financiero_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/widgets/factura_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FacturaConfirmScreen extends StatefulWidget {
  final Map<String, dynamic>? datosFactura;

  const FacturaConfirmScreen({super.key, this.datosFactura});

  @override
  State<FacturaConfirmScreen> createState() => _FacturaConfirmScreenState();
}

class _FacturaConfirmScreenState extends State<FacturaConfirmScreen> {
  late String proveedor;
  late double monto;
  late String categoria;
  late String metodo;
  late DateTime fechaOriginal; // 🔹 Fecha original OCR
  late String fechaFormateada; // 🔹 Fecha legible en interfaz
  late String tipo;

  @override
  void initState() {
    super.initState();

    proveedor = widget.datosFactura?['proveedor'] ?? 'Desconocido';
    final valorMonto = widget.datosFactura?['monto'];

    // ✅ Conversión segura del monto
    if (valorMonto is double) {
      monto = valorMonto;
    } else if (valorMonto is String) {
      monto =
          double.tryParse(valorMonto.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    } else {
      monto = 0.0;
    }

    categoria = widget.datosFactura?['categoria'] ?? 'Sin categoría';
    metodo = widget.datosFactura?['metodo'] ?? 'Efectivo';
    tipo = widget.datosFactura?['tipo'] ?? 'egreso';

    // ✅ Procesar fecha del OCR (acepta DateTime o String)
    final fechaOCR = widget.datosFactura?['fecha'];
    if (fechaOCR is DateTime) {
      fechaOriginal = fechaOCR;
    } else {
      fechaOriginal = _parseFechaOCR(fechaOCR?.toString() ?? '');
    }

    fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaOriginal);
  }

  // 🔹 Convierte la fecha del OCR (en formato flexible) a DateTime real
  DateTime _parseFechaOCR(String f) {
    try {
      final limpia = f.replaceAll('.', '-').replaceAll('/', '-').trim();
      return DateTime.parse(limpia);
    } catch (_) {
      return DateTime.now();
    }
  }

  // 🔹 Formato de dinero
  String _formatearMonto(double valor) {
    final format = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );
    return format.format(valor);
  }

  Future<void> _guardarFactura(BuildContext context) async {
    try {
      double valor = monto;
      if (tipo == 'egreso' && valor > 0) valor = -valor;

      await FirebaseFirestore.instance.collection('facturas').add({
        'titulo': proveedor,
        'monto': valor,
        'tipo': tipo,
        'metodo': metodo,
        'categoria': categoria,
        'fecha': fechaOriginal, // ✅ guarda la fecha real del OCR
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tipo == 'egreso'
                  ? "💸 Gasto añadido a tus finanzas"
                  : "💰 Ingreso añadido a tus finanzas",
            ),
            backgroundColor: tipo == 'egreso' ? Colors.red : Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HistorialFinancieroScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al guardar factura: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editarCategoria() {
    final categorias = [
      'Educación',
      'Alimentación',
      'Transporte',
      'Salud',
      'Servicios',
      'Entretenimiento',
      'Ropa',
      'Otros',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Seleccionar Categoría",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ...categorias.map(
              (cat) => ListTile(
                title: Text(cat),
                trailing: categoria == cat
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() => categoria = cat);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarMetodo() {
    final metodos = ['Efectivo', 'Tarjeta', 'Transferencia'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Seleccionar Método de Pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ...metodos.map(
              (met) => ListTile(
                title: Text(met),
                trailing: metodo == met
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() => metodo = met);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editarMonto() {
    final controller = TextEditingController(text: monto.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Monto"),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                monto =
                    double.tryParse(controller.text.replaceAll(',', '.')) ??
                    0.0;
              });
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final montoFormateado = _formatearMonto(monto);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    final tipoColor = tipo == 'ingreso' ? Colors.green : Colors.red;
    final tipoIcon = tipo == 'ingreso'
        ? Icons.arrow_upward
        : Icons.arrow_downward;
    final tipoTexto = tipo == 'ingreso'
        ? 'Ingreso Detectado'
        : 'Gasto Detectado';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Confirmación de factura",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: (screenHeight * 0.022) * scaleFactor,
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: Column(
                  children: [
                    Icon(
                      tipoIcon,
                      color: tipoColor,
                      size: (screenHeight * 0.08) * scaleFactor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tipoTexto,
                      style: TextStyle(
                        color: tipoColor,
                        fontSize: (screenHeight * 0.018) * scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      montoFormateado,
                      style: TextStyle(
                        fontSize: (screenHeight * 0.032) * scaleFactor,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.006),
                    Text(
                      "Total de la factura",
                      style: TextStyle(
                        fontSize: (screenHeight * 0.015) * scaleFactor,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.028),
              Expanded(
                child: ListView(
                  children: [
                    FacturaRow(label: "Proveedor", value: proveedor),
                    GestureDetector(
                      onTap: _editarCategoria,
                      child: FacturaRow(
                        label: "Categoría",
                        value: categoria,
                        editable: true,
                      ),
                    ),
                    GestureDetector(
                      onTap: _editarMetodo,
                      child: FacturaRow(
                        label: "Pagado con",
                        value: metodo,
                        editable: true,
                      ),
                    ),
                    FacturaRow(label: "Fecha", value: fechaFormateada),
                    GestureDetector(
                      onTap: _editarMonto,
                      child: FacturaRow(
                        label: "Total",
                        value: montoFormateado,
                        editable: true,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.055,
                child: ElevatedButton(
                  onPressed: () => _guardarFactura(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    tipo == 'egreso'
                        ? "Añadir gasto a mis finanzas"
                        : "Añadir ingreso a mis finanzas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (screenHeight * 0.018) * scaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}
