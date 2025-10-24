import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FacturaRow extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;

  const FacturaRow({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 48, thickness: 1, color: Color(0xFFC2C1C1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (editable)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
