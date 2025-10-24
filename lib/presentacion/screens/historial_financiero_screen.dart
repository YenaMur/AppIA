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

class HistorialFinancieroScreen extends StatefulWidget {
  const HistorialFinancieroScreen({super.key});

  @override
  State<HistorialFinancieroScreen> createState() =>
      _HistorialFinancieroScreenState();
}

class _HistorialFinancieroScreenState extends State<HistorialFinancieroScreen> {
  String filtroSeleccionado = "Todo"; //  Estado del filtro activo
  String _selectedPeriod = 'Este mes'; // Estado del periodo seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        titleSpacing: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () =>
                NavHelper.navigateAndReplace(context, HomeScreen()),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            "Historial Financiero",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),

      // ===== BODY =====
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildResumenMes(),
              const SizedBox(height: 24),
              _buildFiltros(),
              const SizedBox(height: 32),
              _buildFacturasRecientes(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // ===== BOTÓN FLOTANTE =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          NavHelper.navigateAndReplace(context, ScanAlertScreen());
        },
        child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ===== NAVBAR =====
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
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
              SizedBox(width: 48), // espacio para el FAB
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

  // ======== SECCIONES ========

  Widget _buildResumenMes() {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDCDCDC),
                blurRadius: 8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Encabezado =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Resumen del Mes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "Ver Todo",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getMesActual(),
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),

              const SizedBox(height: 24),

              // ===== Totales =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResumenItem(
                    title: "Ingresos",
                    value: "\$${totalIngresos.toStringAsFixed(0)}",
                    color: Colors.black,
                  ),
                  ResumenItem(
                    title: "Gastos",
                    value: "\$${totalGastos.toStringAsFixed(0)}",
                    color: Colors.red,
                  ),
                  ResumenItem(
                    title: "Balance",
                    value: "\$${balance.toStringAsFixed(0)}",
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
    return Row(
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
      ],
    );
  }

  String _getMesActual() {
    final ahora = DateTime.now()
        .toLocal(); // se ajusta a la zona horaria del dispositivo
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

  Widget _buildFacturasRecientes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Facturas Recientes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            DropdownButton<String>(
              value: _selectedPeriod,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
              underline: const SizedBox(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
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
        const SizedBox(height: 16),

        // Escucha de datos en tiempo real desde Firestore
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
              return const Text(
                "No hay facturas aún",
                style: TextStyle(color: AppColors.textHint),
              );
            }

            final facturas = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final monto = (data['monto'] ?? 0).toDouble();
              final tipo = monto < 0 ? "Gastos" : "Ingresos";
              if (filtroSeleccionado == "Todo") return true;
              return filtroSeleccionado == tipo;
            }).toList();

            return Column(
              children: facturas.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final titulo = data['titulo'] ?? 'Sin título';
                final metodo = data['metodo'] ?? 'Desconocido';
                final fecha = (data['fecha'] as Timestamp).toDate();
                final monto = (data['monto'] ?? 0).toDouble();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FacturaCard(
                    title: titulo,
                    amount: "\$${monto.toStringAsFixed(2)}",
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
                            id: doc.id, //enviamos el ID del documento
                            titulo: titulo,
                            monto: monto,
                            metodo: metodo,
                            categoria: data['categoria'] ?? 'General',
                            fecha: fecha,
                          ),
                        ),
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
