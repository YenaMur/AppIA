import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Widget para mostrar un ítem de gasto en homepage (versión responsive)
class GastoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final String status;

  const GastoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1 : 1.02);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.006),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ==== Ícono circular ====
          Container(
            width: (screenHeight * 0.045) * scaleFactor,
            height: (screenHeight * 0.045) * scaleFactor,
            decoration: BoxDecoration(
              color: AppColors.buttonSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.textPrimary,
              size: (screenHeight * 0.022) * scaleFactor,
            ),
          ),

          SizedBox(width: screenWidth * 0.035),

          // ==== Información principal ====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: (screenHeight * 0.014) * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenHeight * 0.002),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: (screenHeight * 0.0115) * scaleFactor,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.03),

          // ==== Monto y estado ====
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: (screenHeight * 0.015) * scaleFactor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: screenHeight * 0.003),
              Text(
                status,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: (screenHeight * 0.011) * scaleFactor,
                  fontFamily: 'Inter',
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
