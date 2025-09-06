import 'package:bello_front/control/custom_button.dart';
import 'package:flutter/material.dart';

class AnimatedGradientBanner extends StatefulWidget {
  final String title;
  final String subtitle;
  final double height;
  final VoidCallback? onTap;
  final VoidCallback? onButtonPressed;
  final String? buttonText;

  const AnimatedGradientBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.height = 220.0,
    this.onTap,
    this.onButtonPressed,
    this.buttonText,
  });

  @override
  State<AnimatedGradientBanner> createState() => _AnimatedGradientBannerState();
}

class _AnimatedGradientBannerState extends State<AnimatedGradientBanner>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // 定义渐变色序列：紫、蓝、青、红
  final List<List<Color>> _gradientSequence = [
    [const Color(0xFF9C27B0), const Color(0xFF673AB7)], // 紫色
    [const Color(0xFF2196F3), const Color(0xFF3F51B5)], // 蓝色
    [const Color(0xFF00BCD4), const Color(0xFF009688)], // 青色
    [const Color(0xFFE91E63), const Color(0xFFF44336)], // 红色
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 12), // 8秒完成一个完整循环
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    
    // 开始循环动画
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 根据动画进度计算当前渐变色
  List<Color> _getCurrentGradient(double progress) {
    // 将进度映射到0-4的范围，对应4种颜色
    double scaledProgress = progress * _gradientSequence.length;
    int currentIndex = scaledProgress.floor() % _gradientSequence.length;
    int nextIndex = (currentIndex + 1) % _gradientSequence.length;
    double t = scaledProgress - scaledProgress.floor();

    // 在当前颜色和下一个颜色之间插值
    Color startColor = Color.lerp(
      _gradientSequence[currentIndex][0],
      _gradientSequence[nextIndex][0],
      t,
    )!;
    Color endColor = Color.lerp(
      _gradientSequence[currentIndex][1],
      _gradientSequence[nextIndex][1],
      t,
    )!;

    return [startColor, endColor];
  }

  // 创建按钮
  Widget _buildButton() {
    if (widget.onButtonPressed == null || widget.buttonText == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: 200,
      child: CustomButton(
          onPressed: widget.onButtonPressed!,
          text: widget.buttonText!,
        isHalfTransparent: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final currentGradient = _getCurrentGradient(_animation.value);
          
          return Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: currentGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: currentGradient[0].withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 副标题使用白色
                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 按钮
                  _buildButton(),
                  const SizedBox(height: 24,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}