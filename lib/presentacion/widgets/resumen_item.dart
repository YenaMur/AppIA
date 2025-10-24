import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ResumenItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const ResumenItem({
    super.key,
    required this.title,
    required this.value,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
      ],
    );
  }
}
