import 'dart:ui';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:bello_front/model/user_profile.dart';

// 用户定义的纯文字按钮组件数据模型
class TextTap {
  final String title;
  final VoidCallback onTap;
  TextTap({required this.title, required this.onTap});
}

// 带有毛玻璃效果的顶栏组件
class GlassAppBar extends StatefulWidget {
  // 左侧组件
  final Widget? leftWidget;
  // 中间组件
  final Widget? centerWidget;
  // 右侧组件
  final Widget? rightWidget;

  // 为了向后兼容，保留原有参数
  final List<TextTap>? textTaps;
  final Function(String)? onSearch;

  const GlassAppBar({
    super.key,
    this.leftWidget,
    this.centerWidget,
    this.rightWidget,
    this.textTaps,
    this.onSearch,
  });

  @override
  State<GlassAppBar> createState() => _GlassAppBarState();
}

class _GlassAppBarState extends State<GlassAppBar> {
  UserProfile? _userProfile;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // 加载用户信息
  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await UserManager.getUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = userProfile;
        });
      }
    } catch (e) {
      // 如果获取用户信息失败，保持_userProfile为null
    }
  }

  // 构建头像组件
  Widget _buildAvatar() {
    if (_userProfile?.avatar != null && _userProfile!.avatar.isNotEmpty) {
      try {
        final Uint8List avatarBytes = base64Decode(_userProfile!.avatar);
        return CircleAvatar(
          radius: 20.0,
          backgroundImage: MemoryImage(avatarBytes),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.1),
        );
      } catch (e) {
        // 如果头像解码失败，使用默认图标
        return CircleAvatar(
          radius: 20.0,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      }
    } else {
      // 没有头像时使用默认图标
      return CircleAvatar(
        radius: 20.0,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.1),
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }
  }

  // 构建默认左侧组件
  Widget _buildDefaultLeftWidget() {
    if (widget.textTaps == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.textTaps!.map((tap) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: tap.onTap,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              tap.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 构建默认中间组件
  Widget _buildDefaultCenterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty && widget.onSearch != null) {
            widget.onSearch!(value.trim());
          }
        },
        decoration: InputDecoration(
          hintText: '搜索...',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  // 构建默认右侧组件
  Widget _buildDefaultRightWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            context.go('/auth/profile');
          },
          child: _buildAvatar(),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 ClipRect 来限制 BackdropFilter 的作用范围，防止模糊效果扩散到整个屏幕
    return ClipRect(
      child: BackdropFilter(
        // 应用毛玻璃模糊滤镜
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          // 添加一个半透明的背景，让毛玻璃效果更明显
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          ),
          child: Padding(
            // 为顶栏内容添加水平和垂直内边距
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SizedBox(
              height: 56.0, // 设置顶栏的高度
              // 修复：添加宽度约束，让 Row 中的 Expanded 组件能够正常工作
              width: MediaQuery.of(context).size.width,
              child: Row(
                // 使用 mainAxisAlignment.spaceBetween 来将左、中、右三部分分开
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 左侧组件
                  widget.leftWidget ?? _buildDefaultLeftWidget(),

                  // 中间组件
                  Expanded(
                    child: widget.centerWidget ?? _buildDefaultCenterWidget(),
                  ),

                  // 右侧组件
                  widget.rightWidget ?? _buildDefaultRightWidget(),
                  //SizedBox(width: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
