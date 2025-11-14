import 'package:app/core/utils/nav_helper.dart';
import 'package:app/presentacion/home/home_screen.dart';
import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/widgets/resumen_item.dart';
import 'package:app/presentacion/widgets/factura_card.dart';
import 'package:app/presentacion/widgets/nav_item.dart';
import 'package:app/presentacion/widgets/filter_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/presentacion/screens/facturacion_screen.dart';
import 'package:app/core/utils/firestore_helper.dart';
import 'package:intl/intl.dart';

class HistorialFinancieroScreen extends StatefulWidget {
  const HistorialFinancieroScreen({super.key});

  @override
  State<HistorialFinancieroScreen> createState() =>
      _HistorialFinancieroScreenState();
}

class _HistorialFinancieroScreenState extends State<HistorialFinancieroScreen> {
  String filtroSeleccionado = "Todo";
  String _selectedPeriod = 'Este mes';

  // Función para formatear montos con separadores de miles y decimales inteligentes
  String _formatearMonto(double monto) {
    final montoAbs = monto.abs();
    final formatter = NumberFormat('#,##0.##', 'es_CO');
    return "\$${formatter.format(montoAbs)}";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return Scaffold(
      backgroundColor: AppColors.background,

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: screenHeight * 0.1,
        titleSpacing: 0,
        leadingWidth: screenWidth * 0.16,
        leading: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.02,
            top: screenHeight * 0.01,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: (screenHeight * 0.032) * scaleFactor,
            ),
            onPressed: () =>
                NavHelper.navigateAndReplace(context, const HomeScreen()),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.045),
          child: Text(
            "Historial Financiero",
            style: TextStyle(
              fontSize: (screenHeight * 0.025) * scaleFactor,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),

      // ===== BODY =====
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.025),
              _buildResumenMes(screenHeight, screenWidth, scaleFactor),
              SizedBox(height: screenHeight * 0.025),
              _buildFiltros(),
              SizedBox(height: screenHeight * 0.028),
              _buildFacturasRecientes(screenHeight, screenWidth, scaleFactor),
              SizedBox(height: screenHeight * 0.025),
            ],
          ),
        ),
      ),

      // ===== BOTÓN FLOTANTE =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          NavHelper.navigateAndReplace(context, const ScanAlertScreen());
        },
        child: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: (screenHeight * 0.032) * scaleFactor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ===== NAVBAR =====
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: screenHeight * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.home,
                label: "Principal",
                active: false,
                onTap: () {
                  NavHelper.navigateAndReplace(context, const HomeScreen());
                },
              ),
              SizedBox(width: screenWidth * 0.12),
              NavItem(
                icon: Icons.history,
                label: "Historial",
                active: true,
                onTap: () {
                  NavHelper.navigateAndReplace(
                    context,
                    const HistorialFinancieroScreen(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTimeRange _getRangoPorPeriodo(String periodo) {
    final ahora = DateTime.now();
    DateTime inicio;
    DateTime fin = ahora;

    switch (periodo) {
      case 'Hoy':
        inicio = DateTime(ahora.year, ahora.month, ahora.day);
        fin = inicio.add(const Duration(days: 1));
        break;
      case 'Esta semana':
        final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
        inicio = DateTime(
          inicioSemana.year,
          inicioSemana.month,
          inicioSemana.day,
        );
        fin = inicio.add(const Duration(days: 7));
        break;
      case 'Este mes':
        inicio = DateTime(ahora.year, ahora.month, 1);
        fin = DateTime(ahora.year, ahora.month + 1, 1);
        break;
      case 'Últimos 6 meses':
        inicio = DateTime(ahora.year, ahora.month - 5, 1);
        fin = DateTime(ahora.year, ahora.month + 1, 1);
        break;
      case 'Último año':
        inicio = DateTime(ahora.year - 1, ahora.month, ahora.day);
        break;
      default:
        inicio = DateTime(1970); // sin filtro
    }

    return DateTimeRange(start: inicio, end: fin);
  }

  // ======== SECCIONES ========

  Widget _buildResumenMes(
    double screenHeight,
    double screenWidth,
    double scaleFactor,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('facturas')
          .orderBy('fecha', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        double totalIngresos = 0;
        double totalGastos = 0;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final monto = (data['monto'] ?? 0).toDouble();
            if (monto < 0) {
              totalGastos += monto.abs();
            } else {
              totalIngresos += monto;
            }
          }
        }

        final balance = totalIngresos - totalGastos;

        return Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFDCDCDC),
                blurRadius: 8,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Encabezado =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Resumen del Mes",
                    style: TextStyle(
                      fontSize: (screenHeight * 0.015) * scaleFactor,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    "Ver Todo",
                    style: TextStyle(
                      fontSize: (screenHeight * 0.0005) * scaleFactor,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.004),
              Text(
                _getMesActual(),
                style: TextStyle(
                  fontSize: (screenHeight * 0.01) * scaleFactor,
                  color: AppColors.textHint,
                  fontFamily: 'Inter',
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // ===== Totales =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResumenItem(
                    title: "Ingresos",
                    value: _formatearMonto(totalIngresos),
                    color: Colors.black,
                  ),
                  ResumenItem(
                    title: "Gastos",
                    value: _formatearMonto(totalGastos),
                    color: Colors.red,
                  ),
                  ResumenItem(
                    title: "Balance",
                    value: _formatearMonto(balance),
                    color: balance >= 0 ? Colors.black : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterButton(
            label: "Todo",
            selected: filtroSeleccionado == "Todo",
            onTap: () => setState(() => filtroSeleccionado = "Todo"),
          ),
          FilterButton(
            label: "Ingresos",
            selected: filtroSeleccionado == "Ingresos",
            onTap: () => setState(() => filtroSeleccionado = "Ingresos"),
          ),
          FilterButton(
            label: "Gastos",
            selected: filtroSeleccionado == "Gastos",
            onTap: () => setState(() => filtroSeleccionado = "Gastos"),
          ),
          SizedBox(width: 8), // Padding final para mejor scroll
        ],
      ),
    );
  }

  String _getMesActual() {
    final ahora = DateTime.now().toLocal();
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${meses[ahora.month - 1]} ${ahora.year}';
  }

  Widget _buildFacturasRecientes(
    double screenHeight,
    double screenWidth,
    double scaleFactor,
  ) {
    // 🔹 Define el rango según el periodo seleccionado
    DateTimeRange _getRangoPorPeriodo(String periodo) {
      final ahora = DateTime.now();
      DateTime inicio;
      DateTime fin = ahora;

      switch (periodo) {
        case 'Hoy':
          inicio = DateTime(ahora.year, ahora.month, ahora.day);
          fin = inicio.add(const Duration(days: 1));
          break;
        case 'Esta semana':
          final inicioSemana = ahora.subtract(
            Duration(days: ahora.weekday - 1),
          );
          inicio = DateTime(
            inicioSemana.year,
            inicioSemana.month,
            inicioSemana.day,
          );
          fin = inicio.add(const Duration(days: 7));
          break;
        case 'Este mes':
          inicio = DateTime(ahora.year, ahora.month, 1);
          fin = DateTime(ahora.year, ahora.month + 1, 1);
          break;
        case 'Últimos 6 meses':
          inicio = DateTime(ahora.year, ahora.month - 5, 1);
          fin = DateTime(ahora.year, ahora.month + 1, 1);
          break;
        case 'Último año':
          inicio = DateTime(ahora.year - 1, ahora.month, ahora.day);
          fin = DateTime(ahora.year, ahora.month, ahora.day);
          break;
        default:
          inicio = DateTime(1970);
      }

      return DateTimeRange(start: inicio, end: fin);
    }

    // 🔹 UI principal
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Facturas Recientes",
                style: TextStyle(
                  fontSize: (screenHeight * 0.015) * scaleFactor,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            DropdownButton<String>(
              value: _selectedPeriod,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: (screenHeight * 0.015) * scaleFactor,
              ),
              underline: const SizedBox(),
              style: TextStyle(
                fontSize: (screenHeight * 0.013) * scaleFactor,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
              items: const [
                DropdownMenuItem(value: 'Hoy', child: Text('Hoy')),
                DropdownMenuItem(
                  value: 'Esta semana',
                  child: Text('Esta semana'),
                ),
                DropdownMenuItem(value: 'Este mes', child: Text('Este mes')),
                DropdownMenuItem(
                  value: 'Últimos 6 meses',
                  child: Text('Últimos 6 meses'),
                ),
                DropdownMenuItem(
                  value: 'Último año',
                  child: Text('Último año'),
                ),
              ],
              onChanged: (value) => setState(() => _selectedPeriod = value!),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),

        // 🔹 Escucha de facturas
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('facturas')
              .orderBy('fecha', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text(
                "No hay facturas aún",
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: (screenHeight * 0.014) * scaleFactor,
                ),
              );
            }

            // 🔹 Filtrar facturas según tipo y fecha
            final rango = _getRangoPorPeriodo(_selectedPeriod);

            final facturas = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final monto = (data['monto'] ?? 0).toDouble();
              final tipo = monto < 0 ? "Gastos" : "Ingresos";
              final fecha = (data['fecha'] as Timestamp).toDate();

              final coincideTipo =
                  (filtroSeleccionado == "Todo" || filtroSeleccionado == tipo);
              final coincideFecha =
                  fecha.isAfter(rango.start) && fecha.isBefore(rango.end);

              return coincideTipo && coincideFecha;
            }).toList();

            if (facturas.isEmpty) {
              return Text(
                "No hay facturas en este periodo",
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: (screenHeight * 0.014) * scaleFactor,
                ),
              );
            }

            // 🔹 Mostrar las tarjetas
            return Column(
              children: facturas.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final titulo = data['titulo'] ?? 'Sin título';
                final metodo = data['metodo'] ?? 'Desconocido';
                final fecha = (data['fecha'] as Timestamp).toDate();
                final monto = (data['monto'] ?? 0).toDouble();

                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.012),
                  child: FacturaCard(
                    title: titulo,
                    amount: _formatearMonto(monto),
                    method: metodo,
                    date: "${fecha.day}/${fecha.month}/${fecha.year}",
                    category: data['categoria'] ?? 'General',
                    color: monto < 0
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF00C37D),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacturacionScreen(
                            id: doc.id,
                            titulo: titulo,
                            monto: monto,
                            metodo: metodo,
                            categoria: data['categoria'] ?? 'General',
                            fecha: fecha,
                          ),
                        ),
                      );
                    },
                    onDelete: () async {
                      await FirestoreHelper.eliminarFactura(
                        context,
                        doc.id,
                        titulo,
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
