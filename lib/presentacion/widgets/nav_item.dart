import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? AppColors.primary : AppColors.textHint),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primary : AppColors.textHint,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
