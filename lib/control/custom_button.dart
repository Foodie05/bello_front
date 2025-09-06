import 'package:flutter/material.dart';

/// 自定义按钮组件
class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isHalfTransparent;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isHalfTransparent=false
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: _isHovered 
              ? colorScheme.primary.withOpacity(0.9)
              : (widget.isHalfTransparent?colorScheme.primary.withAlpha(150):colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.primary,
            width: 0.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      widget.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}