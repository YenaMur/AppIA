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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.background
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
