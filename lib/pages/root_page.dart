import 'dart:convert';
import 'dart:typed_data';
import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/routes/home_page.dart';
import 'package:bello_front/routes/passage_page.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:bello_front/widgets/glass_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bello_front/util.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentIndex = 0;
  final GlobalKey<PassagePageState> _passagePageKey =
      GlobalKey<PassagePageState>();
  late List<Widget> pages;
  bool _isBuild = false;
  late Widget _avatar;
  String _currentSearchType = 'keyword'; // 'keyword', 'author', 'label'
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    pages = [HomePage(), PassagePage(key: _passagePageKey)];
    _getAvatar();
  }

  _getAvatar() async {
    _avatar = await _buildAvatar();
    setState(() {
      _isBuild = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 处理搜索
  void _handleSearch(String keyword) {
    // 切换到文章页面
    setState(() {
      currentIndex = 1;
    });
    // 根据搜索类型执行搜索
    final passagePageState = _passagePageKey.currentState;
    if (passagePageState != null) {
      // 设置搜索类型
      passagePageState.setSearchType(_currentSearchType);
      // 执行搜索（空内容时获取所有文章）
      passagePageState.searchPassages(keyword);
    }
  }

  // 显示搜索弹窗
  void _showSearchDialog() {
    final TextEditingController dialogSearchController = TextEditingController();
    String dialogSearchType = _currentSearchType;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('搜索'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 搜索类型选择
                  Row(
                    children: [
                      const Text('搜索类型：'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: dialogSearchType,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'keyword', child: Text('关键字')),
                            DropdownMenuItem(value: 'author', child: Text('作者')),
                            DropdownMenuItem(value: 'label', child: Text('标签')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                dialogSearchType = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 搜索输入框
                  TextField(
                    controller: dialogSearchController,
                    decoration: InputDecoration(
                      hintText: _getSearchHintForDialogType(dialogSearchType),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentSearchType = dialogSearchType;
                      });
                      _handleSearch(value.trim());
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentSearchType = dialogSearchType;
                    });
                    _handleSearch(dialogSearchController.text.trim());
                  },
                  child: const Text('搜索'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 构建左侧组件
  Widget _buildLeftWidget() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        TextButton(
          onPressed: () {
            currentIndex = 0;
            setState(() {});
          },
          child: Text(
            '首页',
            style: TextStyle(
              color: currentIndex == 0
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.7),
              fontWeight: currentIndex == 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {
            currentIndex = 1;
            setState(() {});
          },
          child: Text(
            '文章',
            style: TextStyle(
              color: currentIndex == 1
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.7),
              fontWeight: currentIndex == 1
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  // 构建中间组件
  Widget _buildCenterWidget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    if (isMobile) {
      // 手机端：只显示搜索按钮
      return Container();
    }
    
    // 桌面端：显示完整搜索框
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                // 空内容时也执行搜索获取所有文章
                _handleSearch(value.trim());
              },
              decoration: InputDecoration(
                hintText: _getSearchHint(),
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
          ),
          const SizedBox(width: 8),
          // 搜索类型选择
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: DropdownButton<String>(
              value: _currentSearchType,
              underline: const SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
              items: const [
                DropdownMenuItem(value: 'keyword', child: Text('关键字')),
                DropdownMenuItem(value: 'author', child: Text('作者')),
                DropdownMenuItem(value: 'label', child: Text('标签')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSearchType = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 获取搜索提示文本
  String _getSearchHint() {
    switch (_currentSearchType) {
      case 'author':
        return '搜索作者...';
      case 'label':
        return '搜索标签...';
      default:
        return '搜索关键字...';
    }
  }

  // 获取弹窗搜索提示文本
  String _getSearchHintForDialogType(String searchType) {
    switch (searchType) {
      case 'author':
        return '搜索作者...';
      case 'label':
        return '搜索标签...';
      default:
        return '搜索关键字...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: pages[currentIndex],
            ),
          ),
          Positioned(
            top: 0,
            child: GlassAppBar(
              leftWidget: _buildLeftWidget(),
              centerWidget: _buildCenterWidget(),
              rightWidget: _buildRightWidget(),
            ),
          ),
        ],
      ),
    );
  }

  // 构建右侧组件
  Widget _buildRightWidget() {
    bool isMobile=MediaQuery.of(context).size.width<768;
    return Row(
      children: [
        if(isMobile)
          IconButton(
            onPressed: _showSearchDialog,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        Consumer<ThemeManager>(
          builder: (context, themeManager, child) {
            return IconButton(
              onPressed: themeManager.toggleTheme,
              icon: Icon(
                themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              tooltip: themeManager.isDarkMode ? '切换到浅色主题' : '切换到深色主题',
            );
          },
        ),
        SizedBox(width: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.go('/auth/profile');
              },
              child: _isBuild
                  ? _avatar
                  : CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }

  Future<Widget> _buildAvatar() async {
    UserProfile? _userProfile = await UserManager.getUserProfile();
    if (_userProfile?.avatar != null && _userProfile!.avatar.isNotEmpty) {
      try {
        final Uint8List avatarBytes = base64Decode(_userProfile.avatar);
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
}
