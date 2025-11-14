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
    final screenHeight = MediaQuery.of(context).size.height;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return Flexible(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: (screenHeight * 0.015) * scaleFactor,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Inter',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.004),
          Text(
            title,
            style: TextStyle(
              fontSize: (screenHeight * 0.012) * scaleFactor,
              color: AppColors.textHint,
              fontFamily: 'Inter',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
