import 'package:flutter/material.dart';
import 'package:app/core/constants/app_colors.dart';

class FacturaRow extends StatefulWidget {
  final String label;
  final String value;
  final bool editable;
  final TextEditingController? controller;
  final TextStyle? labelStyle; // 🔹 Nuevo
  final TextStyle? valueStyle; // 🔹 Nuevo

  const FacturaRow({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
    this.controller,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  State<FacturaRow> createState() => _FacturaRowState();
}

class _FacturaRowState extends State<FacturaRow> {
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController =
        widget.controller ?? TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant FacturaRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _internalController.text != widget.value) {
      _internalController.text = widget.value;
    }
  }

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenHeight < 700
        ? 0.9
        : (screenHeight > 900 ? 1.2 : 1.05);

    return Column(
      children: [
        Divider(
          height: screenHeight * 0.055,
          thickness: 1,
          color: const Color(0xFFC2C1C1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Etiqueta + ícono
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.label,
                      style:
                          widget.labelStyle ??
                          TextStyle(
                            fontSize: (screenHeight * 0.016) * scaleFactor,
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.editable)
                    GestureDetector(
                      onTap: _toggleEditing,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.01),
                        child: Icon(
                          Icons.edit_outlined,
                          size: (screenHeight * 0.018) * scaleFactor,
                          color: _isEditing ? Colors.blue : AppColors.textHint,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),

            // Campo o texto
            Flexible(
              flex: 2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                        controller: _internalController,
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
                        style:
                            widget.valueStyle ??
                            TextStyle(
                              fontSize: (screenHeight * 0.016) * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                            ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          widget.value.isNotEmpty ? widget.value : '—',
                          textAlign: TextAlign.right,
                          style:
                              widget.valueStyle ??
                              TextStyle(
                                fontSize: (screenHeight * 0.016) * scaleFactor,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                          overflow: TextOverflow.ellipsis,
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
