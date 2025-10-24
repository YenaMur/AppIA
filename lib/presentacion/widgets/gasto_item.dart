import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Widget para mostrar un ítem de gasto en homepage
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.buttonSecondary,
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(date, style: const TextStyle(fontSize: 12)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 2,
            ), // Espacio entre el monto y el estado
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
