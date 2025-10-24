import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';

class FacturaRow extends StatefulWidget {
  final String label;
  final String value;
  final bool editable;
  final TextEditingController? controller;

  const FacturaRow({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
    this.controller,
  });

  @override
  State<FacturaRow> createState() => _FacturaRowState();
}

class _FacturaRowState extends State<FacturaRow> {
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();

  void _toggleEditing() {
    if (widget.editable) {
      setState(() => _isEditing = !_isEditing);
      if (_isEditing) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        _focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 48, thickness: 1, color: Color(0xFFC2C1C1)),

        // ====== FILA PRINCIPAL ======
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== Etiqueta + Ícono =====
            Row(
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.editable)
                  GestureDetector(
                    onTap: _toggleEditing,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: _isEditing ? Colors.blue : AppColors.textHint,
                      ),
                    ),
                  ),
              ],
            ),

            // ===== Campo o texto =====
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 180,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isEditing ? Colors.blue : Colors.transparent,
                  width: 1.3,
                ),
              ),
              child: widget.editable
                  ? TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: _isEditing,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.background,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        widget.value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
