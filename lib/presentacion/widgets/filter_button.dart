import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap; //  nuevo parámetro

  const FilterButton({
    super.key,
    required this.label,
    this.selected = false,
    required this.onTap, //  lo hacemos obligatorio
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        // detecta taps
        onTap: onTap,
        child: Container(
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
