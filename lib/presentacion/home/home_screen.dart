import 'package:app/presentacion/screens/historial_financiero_screen.dart';
import 'package:app/presentacion/screens/scan_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_texts.dart';
import '../../core/utils/nav_helper.dart';
import '../widgets/category_chips.dart';
import '../widgets/gasto_item.dart';
import '../widgets/nav_item.dart';
import '../widgets/resumen_card.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String _selectedPeriod = 'Esta semana';
  String _selectedCategory = "Todas"; // 🔹 Nueva variable de filtro
  bool _hayNuevoConsejo = true; // 🔔 Muestra el puntico si hay consejo nuevo
  DateTime? _lastTipTime; // control simple
  Timer? _tipTimer; // ticker 5 min

  final List<String> _consejos = [
    "💡 Ahorra al menos el 10% de tus ingresos cada mes.",
    "🛒 Antes de comprar, pregúntate si es una necesidad o un deseo.",
    "🌱 Compra productos locales y reduce tu huella ambiental.",
    "📊 Registra tus pequeños gastos, los 'goteros' también suman.",
    "⚡ Reduce tu consumo eléctrico desconectando equipos que no uses.",
    "💰 Prioriza pagar tus deudas con mayor interés primero.",
    "🥗 Planifica tus compras semanales para evitar desperdicios.",
    "💡 Ahorra al menos el 10% de todo ingreso que recibas, sin excusas.",
    "🪙 Divide tu dinero en tres partes: necesidades, ahorro e inversión.",
    "💵 Antes de gastar, pregúntate si ese gasto te acerca o te aleja de tus metas.",
    "📈 Si suben tus ingresos, no subas tu estilo de vida tan rápido.",
    "💸 Ahorra primero, gasta después. No al revés.",
    "💰 Automatiza tus ahorros: que se descuente apenas recibas tu ingreso.",
    "🧩 Un gasto pequeño repetido cada día puede vaciar tu cuenta al mes.",
    "⚖️ No uses crédito para cubrir gastos fijos, solo emergencias o inversión.",
    "💳 Paga tus tarjetas de crédito a tiempo. Los intereses son enemigos silenciosos.",
    "📅 Prioriza pagar primero las deudas con mayor tasa de interés.",
    "💡 Una deuda no es mala si te genera más ingresos o aprendizaje.",
    "💼 No pongas todo tu dinero en un solo lugar. Diversifica.",
    "💹 El interés compuesto es tu mejor aliado… si empiezas hoy.",
    "🌿 Compra solo lo que realmente necesitas. Lo barato innecesario sale caro.",
    "🛍️ Planea tus compras: evita decisiones impulsivas.",
    "🚶‍♀️ Usa transporte sostenible. Tu bolsillo y el planeta lo agradecerán.",
    "📦 Evita las compras por emoción, espera 24 horas antes de decidir.",
    "🧘‍♂️ La disciplina financiera vale más que un aumento de sueldo.",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTipTicker(); // ⏱️ arranca el ticker
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTipTicker();
    super.dispose();
  }

  // Pausa/reanuda cuando la app cambia de estado (foreground/background)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTipTicker();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopTipTicker();
    }
  }

  void _startTipTicker() {
    _tipTimer?.cancel();
    // lanza badge al iniciar si nunca se mostró hoy (opcional)
    if (_lastTipTime == null ||
        DateTime.now().difference(_lastTipTime!).inMinutes >= 5) {
      setState(() => _hayNuevoConsejo = true);
    }
    _tipTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      setState(() {
        _hayNuevoConsejo = true; // 🔴 aparece puntico
      });
    });
  }

  void _stopTipTicker() {
    _tipTimer?.cancel();
    _tipTimer = null;
  }

  void _mostrarConsejo(BuildContext context) {
    setState(() {
      _hayNuevoConsejo = false; // quita puntico al abrir
      _lastTipTime = DateTime.now();
    });

    final randomConsejo = (_consejos..shuffle()).first;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Consejo financiero 💬",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              randomConsejo,
              style: const TextStyle(fontSize: 16, height: 1.35),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.015),

                // ===== AppBar =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu_rounded,
                        size: (screenHeight * 0.028) * scaleFactor,
                      ),
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.buttonSecondary,
                        foregroundColor: AppColors.textPrimary,
                        padding: EdgeInsets.all(screenWidth * 0.02),
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            size: (screenHeight * 0.028) * scaleFactor,
                          ),
                          onPressed: () => _mostrarConsejo(context),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.buttonSecondary,
                            foregroundColor: AppColors.textPrimary,
                            padding: EdgeInsets.all(screenWidth * 0.02),
                          ),
                        ),
                        if (_hayNuevoConsejo)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.012),

                // ===== Saludo =====
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppTexts.greeting,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: (screenHeight * 0.012) * scaleFactor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),
                      Text(
                        "Sofía Lara",
                        style: TextStyle(
                          fontSize: (screenHeight * 0.02) * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // ===== Saldo total y filtro de periodo =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTexts.balanceTitle,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: (screenHeight * 0.012) * scaleFactor,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.004),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('facturas')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "\$0.00",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize:
                                      (screenHeight * 0.015) * scaleFactor,
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
                                final categoria =
                                    data['categoria'] ?? 'General';
                                if (_selectedCategory != "Todas" &&
                                    categoria != _selectedCategory)
                                  continue;

                                final monto = (data['monto'] ?? 0).toDouble();
                                if (monto < 0) {
                                  totalGastos += monto.abs();
                                } else {
                                  totalIngresos += monto;
                                }
                              }
                            }

                            final saldo = totalIngresos - totalGastos;
                            final saldoSeguro = saldo < 0 ? 0 : saldo;

                            return Text(
                              "\$${saldoSeguro.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: (screenHeight * 0.015) * scaleFactor,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Dropdown de periodo
                    DropdownButton<String>(
                      value: _selectedPeriod,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.blue,
                        size: (screenHeight * 0.022) * scaleFactor,
                      ),
                      underline: const SizedBox(),
                      style: TextStyle(
                        fontSize: (screenHeight * 0.012) * scaleFactor,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
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
                        setState(() => _selectedPeriod = value!);
                      },
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // ===== Gráfica de barras =====
                SizedBox(
                  height: screenHeight * 0.27,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('facturas')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "Aún no hay datos para mostrar",
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: (screenHeight * 0.012) * scaleFactor,
                            ),
                          ),
                        );
                      }

                      // 🔹 Filtro por categoría seleccionada
                      final facturasFiltradas = snapshot.data!.docs.where((
                        doc,
                      ) {
                        final data = doc.data() as Map<String, dynamic>;
                        final categoria = data['categoria'] ?? 'General';
                        if (_selectedCategory == "Todas") return true;
                        return categoria == _selectedCategory;
                      }).toList();

                      // 🔹 Cálculos de ingresos y gastos
                      Map<String, double> ingresos = {};
                      Map<String, double> gastos = {};
                      for (var doc in facturasFiltradas) {
                        final data = doc.data() as Map<String, dynamic>;
                        final cat = data['categoria'] ?? 'General';
                        final monto = (data['monto'] ?? 0).toDouble();
                        if (monto >= 0) {
                          ingresos[cat] = (ingresos[cat] ?? 0) + monto;
                        } else {
                          gastos[cat] = (gastos[cat] ?? 0) + monto.abs();
                        }
                      }

                      final cats = {...ingresos.keys, ...gastos.keys}.toList();
                      if (cats.isEmpty) {
                        return Center(
                          child: Text(
                            "No hay datos en esta categoría",
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: (screenHeight * 0.012) * scaleFactor,
                            ),
                          ),
                        );
                      }

                      final bars = List.generate(cats.length, (i) {
                        final c = cats[i];
                        final ing = ingresos[c] ?? 0;
                        final gas = gastos[c] ?? 0;
                        return BarChartGroupData(
                          x: i,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: ing,
                              color: Colors.blue,
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            BarChartRodData(
                              toY: gas,
                              color: Colors.redAccent,
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ],
                        );
                      });

                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  final i = v.toInt();
                                  if (i < 0 || i >= cats.length) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.005,
                                    ),
                                    child: Text(
                                      cats[i],
                                      style: TextStyle(
                                        fontSize:
                                            (screenHeight * 0.012) *
                                            scaleFactor,
                                        fontFamily: 'Inter',
                                      ),
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
                          barGroups: bars,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.028),

                // ===== Tarjetas resumen =====
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('facturas')
                            .snapshots(),
                        builder: (context, snapshot) {
                          double total = 0;
                          if (snapshot.hasData) {
                            for (var doc in snapshot.data!.docs) {
                              final d = doc.data() as Map<String, dynamic>;
                              final categoria = d['categoria'] ?? 'General';
                              if (_selectedCategory != "Todas" &&
                                  categoria != _selectedCategory)
                                continue;

                              final monto = (d['monto'] ?? 0).toDouble();
                              if (monto > 0) total += monto;
                            }
                          }
                          return ResumenCard(
                            color: AppColors.primary,
                            icon: Icons.arrow_upward_rounded,
                            title: "Ingresos",
                            amount: "\$${total.toStringAsFixed(2)}",
                            iconColor: AppColors.background,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Flexible(
                      flex: 1,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('facturas')
                            .snapshots(),
                        builder: (context, snapshot) {
                          double total = 0;
                          if (snapshot.hasData) {
                            for (var doc in snapshot.data!.docs) {
                              final d = doc.data() as Map<String, dynamic>;
                              final categoria = d['categoria'] ?? 'General';
                              if (_selectedCategory != "Todas" &&
                                  categoria != _selectedCategory)
                                continue;

                              final monto = (d['monto'] ?? 0).toDouble();
                              if (monto < 0) total += monto.abs();
                            }
                          }
                          return ResumenCard(
                            color: AppColors.error,
                            icon: Icons.arrow_downward_rounded,
                            title: "Gastos",
                            amount: "\$${total.toStringAsFixed(2)}",
                            iconColor: AppColors.background,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // ===== Categorías filtrables =====
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('facturas')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        "Cargando categorías...",
                        style: TextStyle(
                          fontSize: (screenHeight * 0.012) * scaleFactor,
                          color: AppColors.textHint,
                        ),
                      );
                    }

                    final cats =
                        snapshot.data!.docs
                            .map(
                              (d) =>
                                  (d.data()
                                      as Map<String, dynamic>)['categoria'] ??
                                  'General',
                            )
                            .toSet()
                            .toList()
                          ..sort();
                    cats.insert(0, "Todas");

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth * 0.02),
                          ...cats.map((c) {
                            final isSelected = _selectedCategory == c;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: screenWidth * 0.02,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedCategory = c);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.008,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.15)
                                        : AppColors.buttonSecondary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 1.3,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getIconForCategory(c),
                                        size:
                                            (screenHeight * 0.015) *
                                            scaleFactor,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                      SizedBox(width: screenWidth * 0.015),
                                      Text(
                                        c,
                                        style: TextStyle(
                                          fontSize:
                                              (screenHeight * 0.013) *
                                              scaleFactor,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.025),

                // ===== Lista de gastos recientes =====
                Text(
                  "Tus últimos gastos",
                  style: TextStyle(
                    fontSize: (screenHeight * 0.018) * scaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('facturas')
                      .orderBy('fecha', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    double totalIngresos = 0;
                    double totalGastos = 0;

                    if (totalIngresos > 0) {
                      final porcentajeGastos =
                          (totalGastos / totalIngresos) * 100;
                      if (porcentajeGastos >= 75) {
                        Future.microtask(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.orange.shade600,
                              duration: const Duration(seconds: 4),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "💡 Consejo: intenta ahorrar al menos el 25% de tus ingresos cada mes.",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }
                    }

                    final docs = snapshot.data!.docs.where((d) {
                      final data = d.data() as Map<String, dynamic>;
                      final categoria = data['categoria'] ?? 'General';
                      if (_selectedCategory != "Todas" &&
                          categoria != _selectedCategory)
                        return false;
                      return true;
                    }).toList();

                    if (docs.isEmpty) {
                      return Text(
                        "No hay gastos recientes",
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: (screenHeight * 0.012) * scaleFactor,
                        ),
                      );
                    }

                    final ahora = DateTime.now();
                    final haceDosDias = ahora.subtract(const Duration(days: 2));
                    final recientes = docs.where((d) {
                      final data = d.data() as Map<String, dynamic>;
                      final fecha = (data['fecha'] as Timestamp).toDate();
                      final monto = (data['monto'] ?? 0).toDouble();
                      return monto < 0 && fecha.isAfter(haceDosDias);
                    }).toList();

                    if (recientes.isEmpty) {
                      return Text(
                        "No hay gastos en los últimos 2 días",
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: (screenHeight * 0.012) * scaleFactor,
                        ),
                      );
                    }

                    return Column(
                      children: recientes.map((d) {
                        final data = d.data() as Map<String, dynamic>;
                        final titulo = data['titulo'] ?? 'Sin título';
                        final monto = (data['monto'] ?? 0).toDouble();
                        final cat = data['categoria'] ?? 'General';
                        final fecha = DateFormat(
                          "MMM d, y",
                          "es_ES",
                        ).format((data['fecha'] as Timestamp).toDate());

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012,
                          ),
                          child: GastoItem(
                            icon: _getIconForCategory(cat),
                            title: titulo,
                            date: fecha,
                            amount: "-\$${monto.abs().toStringAsFixed(2)}",
                            status: "Pagado",
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.025),
              ],
            ),
          ),
        ),
      ),

      // FAB y BottomNav
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () =>
            NavHelper.navigateAndReplace(context, const ScanAlertScreen()),
        child: Icon(
          Icons.camera_alt_rounded,
          size: (screenHeight * 0.032) * scaleFactor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                active: true,
                onTap: () =>
                    NavHelper.navigateAndReplace(context, const HomeScreen()),
              ),
              SizedBox(width: screenWidth * 0.12),
              NavItem(
                icon: Icons.history,
                label: "Historial",
                active: false,
                onTap: () => NavHelper.navigateAndReplace(
                  context,
                  const HistorialFinancieroScreen(),
                ),
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
      case 'educación':
      case 'estudios':
        return Icons.school;
      case 'salud':
        return Icons.local_hospital;
      case 'compras':
        return Icons.shopping_bag;
      case 'servicios':
        return Icons.lightbulb;
      default:
        return Icons.category;
    }
  }
}
