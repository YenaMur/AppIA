import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/constants/app_texts.dart';
import '../../core/utils/nav_helper.dart';
import '../widgets/category_chips.dart';
import '../widgets/gasto_item.dart';
import '../widgets/nav_item.dart';
import '../widgets/resumen_card.dart'; // para la gráfica de barras

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPeriod = 'Esta semana';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== APPBAR PERSONALIZADO =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      AppTexts.greeting,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Sofía Lara",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===== SALDO Y FILTRO DE SEMANA =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        AppTexts.balanceTitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "\$50,000.00",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Filtro de semana / periodo
                  DropdownButton<String>(
                    value: _selectedPeriod, // variable del estado
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.blue,
                    ),
                    underline: const SizedBox(), // quita la línea inferior
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    items: const [
                      DropdownMenuItem(value: 'Hoy', child: Text('Hoy')),
                      DropdownMenuItem(
                        value: 'Esta semana',
                        child: Text('Esta semana'),
                      ),
                      DropdownMenuItem(
                        value: 'Este mes',
                        child: Text('Este mes'),
                      ),
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

              // ===== GRÁFICA DE BARRAS =====
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = [
                              'Transporte',
                              'Alimentación',
                              'Salidas',
                              'Estudios',
                            ];
                            return Text(
                              labels[value.toInt() % labels.length],
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(toY: 50, color: Colors.blue),
                          BarChartRodData(toY: 40, color: Colors.purple),
                          BarChartRodData(toY: 60, color: Colors.cyan),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(toY: 30, color: Colors.blue),
                          BarChartRodData(toY: 50, color: Colors.purple),
                          BarChartRodData(toY: 35, color: Colors.cyan),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(toY: 45, color: Colors.blue),
                          BarChartRodData(toY: 20, color: Colors.purple),
                          BarChartRodData(toY: 25, color: Colors.cyan),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(toY: 70, color: Colors.blue),
                          BarChartRodData(toY: 40, color: Colors.purple),
                          BarChartRodData(toY: 65, color: Colors.cyan),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===== TARJETAS INGRESOS / GASTOS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ResumenCard(
                      color: AppColors.primary,
                      icon: Icons.arrow_upward_rounded,
                      title: "Ingresos",
                      amount: "\$23,000.00",
                      iconColor: AppColors.background,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ResumenCard(
                      color: AppColors.error,
                      icon: Icons.arrow_downward_rounded,
                      title: "Gastos",
                      amount: "\$15,000.00",
                      iconColor: AppColors.background,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== CHIPS DE CATEGORÍAS =====
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    SizedBox(width: 8),
                    CategoryChip(
                      label: "Transporte",
                      icon: Icons.directions_bus,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(label: "Alimentación", icon: Icons.fastfood),
                    SizedBox(width: 8),
                    CategoryChip(label: "Estudios", icon: Icons.school),
                    SizedBox(width: 8),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== LISTA DE GASTOS =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Tus últimos gastos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Ver más",
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GastoItem(
                icon: Icons.local_cafe,
                title: "Starbucks",
                date: "Sep 13, 2025",
                amount: "-\$12,000.00",
                status: "Pagado",
              ),
              GastoItem(
                icon: Icons.directions_bus,
                title: "Bus - MIO",
                date: "Sep 13, 2025",
                amount: "-\$6,000.00",
                status: "Pagado",
              ),
              GastoItem(
                icon: Icons.fastfood,
                title: "McDonalds",
                date: "Sep 10, 2025",
                amount: "-\$20,000.00",
                status: "Pagado",
              ),
            ],
          ),
        ),
      ),

      // ===== BOTÓN FLOTANTE CENTRAL + NAV BAR =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          NavHelper.navigateAndReplace(context, const ScanAlertScreen());
        },
        child: const Icon(Icons.camera_alt_outlined, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              NavItem(icon: Icons.home, label: "Principal", active: true),
              SizedBox(width: 48), // espacio para el FAB
              NavItem(icon: Icons.history, label: "Historial"),
            ],
          ),
        ),
      ),
    );
  }
}
