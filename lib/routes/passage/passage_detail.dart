import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/request_model/passage/passage_delete.dart';
import 'package:bello_front/request_model/passage/passage_edit.dart';
import 'package:bello_front/request_model/passage/passage_get.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/util/random_string.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:bello_front/model/passage.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:bello_front/widgets/glass_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:bello_front/util.dart';

import '../../js_interop.dart';

class PassageDetailPage extends StatefulWidget {
  final String passageId;

  const PassageDetailPage({super.key, required this.passageId});

  @override
  State<PassageDetailPage> createState() => _PassageDetailPageState();
}

class _PassageDetailPageState extends State<PassageDetailPage> {
  Passage? _passage;
  bool _isLoading = true;
  String? _error;
  String? _userToken;
  UserProfile? _userProfile;
  late String _markdownKey;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadPassage();
    _markdownKey = 'Initial Key';
  }

  // 加载用户信息
  Future<void> _loadUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('token');
      _userProfile = await UserManager.getUserProfile();
    } catch (e) {
      _userProfile = null;
      print('加载用户信息失败: $e');
    }
  }

  // 加载文章详情
  Future<void> _loadPassage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var request = PassageGetRequest(
        token: token ?? '',
        id: int.tryParse(widget.passageId) ?? 0,
      );
      final response = await dio.post(
        baseUrl + passageGet,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          _passage = Passage.fromJson(jsonDecode(responseData));
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = '网络请求失败';
          _isLoading = false;
        });
      }
    } catch (e) {
      context.go('/404');
    }
  }

  // 分享文章
  Future<void> _sharePassage() async {
    if (_passage == null) return;

    try {
      final shareUrl =
          'https://cruty.cn/passage/detail?id=${widget.passageId}';
      await Clipboard.setData(ClipboardData(
        text: '你的朋友给你分享了一篇文章——点击访问$shareUrl'
      ));

      if (mounted) {
        ToastUtil.showSuccess('分享链接已复制到剪贴板');
      }
    } catch (e) {
      if (mounted) {
        ToastUtil.showError('复制分享链接失败');
      }
    }
  }

  // 编辑文章
  void _editPassage() {
    if (_passage == null || _userToken == null) return;
    context
        .push(
          '/passage/edit',
          extra: PassageEditRequest(
            id: _passage!.id,
            token: _userToken!,
            subject: _passage!.subject,
            body: _passage!.text,
            level: _passage!.level,
            filter: _passage!.labels,
          ),
        )
        .then((_) => _loadPassage());
  }

  // 删除文章
  Future<void> _deletePassage() async {
    if (_passage == null) return;

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这篇文章吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true || _passage == null) return;
    Clipboard.setData(ClipboardData(text: _passage!.text));
    ToastUtil.showInfo('为防止误删，已经将文章复制到剪贴板～');

    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.post(
        baseUrl + passageDelete,
        data: PassageDeleteRequest(
          token: token ?? '',
          id: _passage!.id,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        ToastUtil.showSuccess('文章删除成功');
        context.go('/');
      } else {
        if (mounted) {
          ToastUtil.showError('网络请求失败');
        }
      }
    } catch (e) {
      if (mounted) {
        ToastUtil.showError('删除文章时出错: $e');
      }
    }
  }

  // 检查是否可以编辑
  bool _canEdit() {
    if (_passage == null || _userProfile == null) return false;

    // 管理员可以编辑所有文章
    if (_userProfile!.level == 1) return true;

    // 作者可以编辑自己的文章
    if (_userProfile!.level == 2 && _passage!.belongTo == _userProfile!.id) {
      return true;
    }

    return false;
  }

  // 检查是否可以删除
  bool _canDelete() {
    if (_passage == null || _userProfile == null) return false;

    // 管理员可以删除所有文章
    if (_userProfile!.level == 1) return true;

    // 作者可以删除自己的文章
    if (_userProfile!.level == 2 && _passage!.belongTo == _userProfile!.id) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassAppBar(
                leftWidget: _buildLeftWidget(),
                centerWidget: const Text(
                  '加载中...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                rightWidget: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPassage,
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassAppBar(
                leftWidget: _buildLeftWidget(),
                centerWidget: const Text(
                  '加载失败',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                rightWidget: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
    }

    if (_passage == null) {
      return Scaffold(
        body: Stack(
          children: [
            const Center(child: Text('文章不存在')),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassAppBar(
                leftWidget: _buildLeftWidget(),
                centerWidget: const Text(
                  '文章不存在',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                rightWidget: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 72),

                  // 文章信息
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _passage!.subject,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _passage!.author,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_passage!.datetime.year}-${_passage!.datetime.month.toString().padLeft(2, '0')}-${_passage!.datetime.day.toString().padLeft(2, '0')} ${_passage!.datetime.hour.toString().padLeft(2, '0')}:${_passage!.datetime.minute.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        if (_passage!.labels.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: _passage!.labels.map((label) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 文章正文
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    //height: MediaQuery.of(context).size.height-242,
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GptMarkdown(
                      key: Key(_markdownKey),
                      _passage!.text,
                      onLinkTap: (text,link){
                        open(link??'', '_blank');
                    },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // GlassAppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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

  // 构建左侧组件
  Widget _buildLeftWidget() {
    return IconButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  // 构建中间组件
  Widget _buildCenterWidget() {
    return Text(
      _passage?.subject ?? '文章详情',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // 构建右侧组件
  Widget _buildRightWidget() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主题切换按钮
        Consumer<ThemeManager>(
          builder: (context, themeManager, child) {
            return IconButton(
              onPressed: () async {
                themeManager.toggleTheme();
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {
                  _markdownKey = randomString(10);
                });
              },
              icon: Icon(
                themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: colorScheme.onSurface,
              ),
              tooltip: themeManager.isDarkMode ? '切换到浅色主题' : '切换到深色主题',
            );
          },
        ),

        // 分享按钮
        IconButton(
          onPressed: _sharePassage,
          icon: Icon(Icons.share, color: colorScheme.onSurface),
          tooltip: '分享',
        ),

        // 编辑按钮
        if (_canEdit())
          IconButton(
            onPressed: _editPassage,
            icon: Icon(Icons.edit, color: colorScheme.onSurface),
            tooltip: '编辑',
          ),

        // 删除按钮
        if (_canDelete())
          IconButton(
            onPressed: _deletePassage,
            icon: Icon(Icons.delete, color: colorScheme.onSurface),
            tooltip: '删除',
          ),
      ],
    );
  }
}
