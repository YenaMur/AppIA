import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FacturaCard extends StatelessWidget {
  final String title;
  final String amount;
  final String method;
  final String date;
  final String category;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete; // Nuevo parámetro

  const FacturaCard({
    super.key,
    required this.title,
    required this.amount,
    required this.method,
    required this.date,
    required this.category,
    required this.color,
    this.onTap,
    this.onDelete, // Nuevo parámetro
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w700,
                          fontSize: (screenHeight * 0.018) * scaleFactor,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.002),
                      Text(
                        category,
                        style: TextStyle(
                          color: AppColors.buttonSecondary,
                          fontSize: (screenHeight * 0.013) * scaleFactor,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón de eliminar
                    if (onDelete != null)
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.015),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: (screenHeight * 0.024) * scaleFactor,
                          ),
                        ),
                      ),
                    if (onDelete != null) SizedBox(width: screenWidth * 0.01),
                    Icon(
                      Icons.expand_more_rounded,
                      color: Colors.white,
                      size: (screenHeight * 0.028) * scaleFactor,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.01),

            // ====== Monto ======
            Center(
              child: Text(
                amount,
                style: TextStyle(
                  fontSize: (screenHeight * 0.045) * scaleFactor,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: screenHeight * 0.008),

            // ====== Método de pago y fecha ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    method,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: (screenHeight * 0.013) * scaleFactor,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: (screenHeight * 0.013) * scaleFactor,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
