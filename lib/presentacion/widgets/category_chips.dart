import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: (screenHeight * 0.02) * scaleFactor,
            color: isSelected ? AppColors.background : AppColors.textPrimary,
          ),
          SizedBox(width: screenWidth * 0.015),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.background
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: (screenHeight * 0.012) * scaleFactor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
