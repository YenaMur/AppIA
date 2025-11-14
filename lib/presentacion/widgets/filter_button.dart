import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    this.selected = false,
    required this.onTap,
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
        height: screenHeight * 0.045,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        margin: EdgeInsets.only(right: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : AppColors.buttonSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: (screenHeight * 0.015) * scaleFactor,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
