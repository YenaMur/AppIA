import 'package:app/core/utils/nav_helper.dart';
import 'package:app/presentacion/screens/camera_preview_screen.dart';
import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:app/presentacion/widgets/resumen_item.dart';
import 'package:app/presentacion/widgets/factura_card.dart';
import 'package:app/presentacion/widgets/nav_item.dart';
import 'package:app/presentacion/widgets/filter_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialFinancieroScreen extends StatefulWidget {
  const HistorialFinancieroScreen({super.key});

  @override
  State<HistorialFinancieroScreen> createState() =>
      _HistorialFinancieroScreenState();
}

class _HistorialFinancieroScreenState extends State<HistorialFinancieroScreen> {
  String filtroSeleccionado = "Todo"; //  Estado del filtro activo
  String _selectedPeriod = 'Este mes'; // 🔹 Estado del periodo seleccionado

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
            onPressed: () => Navigator.pop(context),
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
            children: const [
              NavItem(icon: Icons.home, label: "Principal", active: false),
              SizedBox(width: 48), // espacio para el FAB
              NavItem(icon: Icons.history, label: "Historial", active: true),
            ],
          ),
        ),
      ),
    );
  }

  // ======== SECCIONES ========

  Widget _buildResumenMes() {
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
          const Text(
            "Septiembre 2025",
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ResumenItem(title: "Ingresos", value: "\$650,000"),
              ResumenItem(
                title: "Gastos",
                value: "\$326,250",
                color: Colors.red,
              ),
              ResumenItem(title: "Balance", value: "\$323,750"),
            ],
          ),
        ],
      ),
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

  Widget _buildFacturasRecientes() {
    // Lista de facturas completas
    final facturas = [
      {
        "title": "CAN PUJON",
        "amount": "-\$91.50",
        "method": "Efectivo",
        "date": "25/08/2025",
        "color": const Color(0xFFFF6B6B),
        "tipo": "Gasto",
      },
      {
        "title": "TRABAJO",
        "amount": "\$200,000",
        "method": "Tarjeta Débito",
        "date": "31/08/2025",
        "color": const Color(0xFF00C37D),
        "tipo": "Ingreso",
      },
    ];

    // Filtrar según el botón seleccionado
    final filtradas = facturas.where((f) {
      if (filtroSeleccionado == "Todo") return true;
      if (filtroSeleccionado == "Ingresos") return f["tipo"] == "Ingreso";
      if (filtroSeleccionado == "Gastos") return f["tipo"] == "Gasto";
      return false;
    }).toList();

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

            //  Filtro de periodo (dropdown)
            DropdownButton<String>(
              value: _selectedPeriod,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
              underline: const SizedBox(), // sin línea inferior
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
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Render dinámico
        for (var f in filtradas) ...[
          FacturaCard(
            title: f["title"] as String,
            amount: f["amount"] as String,
            method: f["method"] as String,
            date: f["date"] as String,
            color: f["color"] as Color,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
