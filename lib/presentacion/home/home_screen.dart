import 'package:app/presentacion/screens/historial_financiero_screen.dart';
import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
                    children: [
                      const Text(
                        AppTexts.balanceTitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // === Saldo dinámico desde Firestore ===
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('facturas')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              "\$0.00",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }

                          double totalIngresos = 0;
                          double totalGastos = 0;

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
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

                          // Calcular saldo y evitar negativos
                          final saldo = totalIngresos - totalGastos;
                          final saldoSeguro = saldo < 0 ? 0 : saldo;

                          return Text(
                            "\$${saldoSeguro.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
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
                height: 220,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('facturas')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aún no hay datos para mostrar",
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }

                    // === Agrupamos por categoría ===
                    Map<String, double> ingresosPorCategoria = {};
                    Map<String, double> gastosPorCategoria = {};

                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final categoria = data['categoria'] ?? 'General';
                      final monto = (data['monto'] ?? 0).toDouble();

                      if (monto >= 0) {
                        ingresosPorCategoria[categoria] =
                            (ingresosPorCategoria[categoria] ?? 0) + monto;
                      } else {
                        gastosPorCategoria[categoria] =
                            (gastosPorCategoria[categoria] ?? 0) + monto.abs();
                      }
                    }

                    // === Todas las categorías únicas ===
                    final categorias = {
                      ...ingresosPorCategoria.keys,
                      ...gastosPorCategoria.keys,
                    }.toList();

                    if (categorias.isEmpty) {
                      return const Center(
                        child: Text(
                          "Sin categorías registradas",
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }

                    // === Generar grupos de barras dinámicamente ===
                    final barGroups = List.generate(categorias.length, (index) {
                      final categoria = categorias[index];
                      final ingreso = ingresosPorCategoria[categoria] ?? 0;
                      final gasto = gastosPorCategoria[categoria] ?? 0;

                      return BarChartGroupData(
                        x: index,
                        barsSpace: 4,
                        barRods: [
                          BarChartRodData(
                            toY: ingreso,
                            color: Colors.blue,
                            width: 10,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          BarChartRodData(
                            toY: gasto,
                            color: Colors.redAccent,
                            width: 10,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      );
                    });

                    // === Mostrar gráfica ===
                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= categorias.length)
                                  return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    categorias[index],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: barGroups,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ===== TARJETAS INGRESOS / GASTOS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // === INGRESOS ===
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('facturas')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ResumenCard(
                            color: AppColors.primary,
                            icon: Icons.arrow_upward_rounded,
                            title: "Ingresos",
                            amount: "\$0.00",
                            iconColor: AppColors.background,
                          );
                        }

                        double totalIngresos = 0;

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            final monto = (data['monto'] ?? 0).toDouble();
                            if (monto > 0) totalIngresos += monto;
                          }
                        }

                        // nunca menor que 0
                        final ingresosSeguros = totalIngresos < 0
                            ? 0
                            : totalIngresos;

                        return ResumenCard(
                          color: AppColors.primary,
                          icon: Icons.arrow_upward_rounded,
                          title: "Ingresos",
                          amount: "\$${ingresosSeguros.toStringAsFixed(2)}",
                          iconColor: AppColors.background,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // === GASTOS ===
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('facturas')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ResumenCard(
                            color: AppColors.error,
                            icon: Icons.arrow_downward_rounded,
                            title: "Gastos",
                            amount: "\$0.00",
                            iconColor: AppColors.background,
                          );
                        }

                        double totalGastos = 0;

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            final monto = (data['monto'] ?? 0).toDouble();
                            if (monto < 0) totalGastos += monto.abs();
                          }
                        }

                        // nunca menor que 0
                        final gastosSeguros = totalGastos < 0 ? 0 : totalGastos;

                        return ResumenCard(
                          color: AppColors.error,
                          icon: Icons.arrow_downward_rounded,
                          title: "Gastos",
                          amount: "\$${gastosSeguros.toStringAsFixed(2)}",
                          iconColor: AppColors.background,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ===== CHIPS DE CATEGORÍAS =====
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('facturas')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Cargando categorías..."),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("No hay categorías aún"),
                      );
                    }

                    // Extraer todas las categorías únicas
                    final categorias = snapshot.data!.docs
                        .map(
                          (doc) =>
                              (doc.data()
                                  as Map<String, dynamic>)['categoria'] ??
                              'General',
                        )
                        .toSet()
                        .toList();

                    return Row(
                      children: [
                        const SizedBox(width: 8),
                        ...categorias.map((categoria) {
                          final icono = _getIconForCategory(categoria);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(label: categoria, icon: icono),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

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
                      "No hay gastos recientes",
                      style: TextStyle(color: AppColors.textHint),
                    );
                  }

                  // Fecha límite = hace 2 días
                  final ahora = DateTime.now();
                  final haceDosDias = ahora.subtract(const Duration(days: 2));

                  // Filtrar solo gastos de los últimos 2 días
                  final gastosRecientes = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final monto = (data['monto'] ?? 0).toDouble();
                    final fecha = (data['fecha'] as Timestamp).toDate();
                    return monto < 0 && fecha.isAfter(haceDosDias);
                  }).toList();

                  if (gastosRecientes.isEmpty) {
                    return const Text(
                      "No hay gastos en los últimos 2 días",
                      style: TextStyle(color: AppColors.textHint),
                    );
                  }

                  // Mostrar los gastos como lista de GastoItem
                  return Column(
                    children: gastosRecientes.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final titulo = data['titulo'] ?? 'Sin título';
                      final fecha = (data['fecha'] as Timestamp).toDate();
                      final monto = (data['monto'] ?? 0).toDouble();
                      final categoria = data['categoria'] ?? 'General';

                      // Formato de fecha: Oct 24, 2025
                      final fechaFormateada = DateFormat(
                        "MMM d, y",
                        "es_ES",
                      ).format(fecha);

                      // Ícono según categoría
                      final icono = _getIconForCategory(categoria);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GastoItem(
                          icon: icono,
                          title: titulo,
                          date: fechaFormateada,
                          amount: "-\$${monto.abs().toStringAsFixed(2)}",
                          status: "Pagado",
                        ),
                      );
                    }).toList(),
                  );
                },
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
        child: const Icon(Icons.camera_alt_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                active: true,
                onTap: () {
                  NavHelper.navigateAndReplace(context, const HomeScreen());
                },
              ),
              SizedBox(width: 48), // espacio para el FAB
              NavItem(
                icon: Icons.history,
                label: "Historial",
                active: false,
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

  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'transporte':
        return Icons.directions_bus;
      case 'alimentación':
      case 'restaurantes':
        return Icons.fastfood;
      case 'estudios':
      case 'educación':
        return Icons.school;
      case 'salud':
        return Icons.local_hospital;
      case 'compras':
        return Icons.shopping_bag;
      case 'servicios':
        return Icons.lightbulb;
      default:
        return Icons.category; // ícono genérico
    }
  }
}
