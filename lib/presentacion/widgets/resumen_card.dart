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
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary, // fondo gris claro
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // círculo del ícono
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: color, // usa el color que viene del constructor
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor, // color del ícono (blanco)
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Monto y título
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
