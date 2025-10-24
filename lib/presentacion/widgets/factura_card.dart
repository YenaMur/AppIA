import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FacturaCard extends StatelessWidget {
  final String title;
  final String amount;
  final String method;
  final String date;
  final String category; // nuevo campo
  final Color color;

  final VoidCallback? onTap; // acción al tocar

  const FacturaCard({
    super.key,
    required this.title,
    required this.amount,
    required this.method,
    required this.date,
    required this.category,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 👈 Aquí agregamos el detector del toque
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Título y menú ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // 🔹 mejor alineado
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      category,
                      style: const TextStyle(
                        color: AppColors.buttonSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.expand_more_rounded, color: Colors.white),
              ],
            ),

            const SizedBox(height: 8),

            // ====== Monto ======
            Center(
              child: Text(
                amount,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ====== Método de pago y fecha ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  method,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
