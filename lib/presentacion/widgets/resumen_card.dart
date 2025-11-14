import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ResumenCard extends StatelessWidget {
  final Color color; // color del círculo del ícono
  final IconData icon;
  final String title;
  final String amount;
  final Color iconColor;

  const ResumenCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.amount,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1 : 1.02);

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // círculo del ícono
          Container(
            width: (screenHeight * 0.03) * scaleFactor,
            height: (screenHeight * 0.03) * scaleFactor,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              icon,
              color: iconColor,
              size: (screenHeight * 0.015) * scaleFactor,
            ),
          ),
          SizedBox(
            width: screenWidth * 0.025,
          ), // Reducido de 12 a ~2.5% del ancho
          // Monto y título - ENVUELTO EN EXPANDED
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: (screenHeight * 0.0145) * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenHeight * 0.004),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: (screenHeight * 0.01) * scaleFactor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
