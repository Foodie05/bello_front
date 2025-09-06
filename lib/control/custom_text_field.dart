// lib/control/custom_text_field.dart
import 'package:flutter/material.dart';

/// 自定义文本输入框组件
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool showObscureToggle; // 新增参数

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.showObscureToggle = false, // 默认值为 false
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  bool _isHovered = false;
  late bool _isObscure; // 内部状态，用于控制密码可见性

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // 初始化时使用传入的 obscureText 值
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 根据 showObscureToggle 参数决定使用哪个 suffixIcon
    final Widget? effectiveSuffixIcon = widget.showObscureToggle && widget.obscureText
        ? IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: colorScheme.onSurfaceVariant,
        size: 18,
      ),
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
    )
        : widget.suffixIcon;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _isObscure, // 使用内部状态
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.maxLines,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: _isFocused ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            suffixIcon: effectiveSuffixIcon, // 使用新的 suffixIcon
            filled: true,
            fillColor: _isHovered
                ? colorScheme.surfaceVariant.withOpacity(0.3)
                : colorScheme.surfaceVariant.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.maxLines! > 1 ? 16 : 16,
            ),
          ),
        ),
      ),
    );
  }
}