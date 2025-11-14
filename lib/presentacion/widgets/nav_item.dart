import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Factor de escala adaptativo
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColors.primary.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.005, // ← Añadido para evitar overflow
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active ? AppColors.primary : AppColors.textHint,
              size: (screenHeight * 0.028) * scaleFactor,
            ),
            SizedBox(height: screenHeight * 0.003), // Reducido
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.primary : AppColors.textHint,
                fontSize: (screenHeight * 0.014) * scaleFactor,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
