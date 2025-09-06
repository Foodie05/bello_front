import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 头像选择器组件
class AvatarPicker extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;
  final String? errorText;
  final double size;

  const AvatarPicker({
    super.key,
    required this.onImageSelected,
    this.errorText,
    this.size = 120,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  Uint8List? _imageBytes;
  bool _isHovered = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
        widget.onImageSelected(bytes);
      }
    } catch (e) {
      // 处理选择图片时的错误
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('选择图片失败: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasError = widget.errorText != null;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: _pickImage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasError 
                      ? colorScheme.error 
                      : (_isHovered ? colorScheme.primary : colorScheme.outline.withOpacity(0.3)),
                  width: hasError ? 2.0 : (_isHovered ? 2.0 : 1.0),
                ),
                color: _isHovered 
                    ? colorScheme.surfaceVariant.withOpacity(0.3)
                    : colorScheme.surfaceVariant.withOpacity(0.1),
              ),
              child: _imageBytes != null
                  ? Stack(
                      children: [
                        ClipOval(
                          child: Image.memory(
                            _imageBytes!,
                            width: widget.size,
                            height: widget.size,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_isHovered)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: colorScheme.onError,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 32,
                          color: hasError 
                              ? colorScheme.error 
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '选择头像',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hasError 
                                ? colorScheme.error 
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ]
      ],
    );
  }
}