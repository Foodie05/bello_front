import 'package:bello_front/control/custom_button.dart';
import 'package:bello_front/util/random_string.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:bello_front/request_model/passage/passage_create.dart';
import 'package:bello_front/request_model/passage/passage_edit.dart';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/widgets/glass_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:bello_front/util.dart';

class PassageEditPage extends StatefulWidget {
  final dynamic passageData; // 可以是PassageCreateRequest或PassageEditRequest

  const PassageEditPage({super.key, required this.passageData});

  @override
  State<PassageEditPage> createState() => _PassageEditPageState();
}

class _PassageEditPageState extends State<PassageEditPage> {
  final Dio dio = Dio();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  bool _isEditMode = false;
  List<String> _tags = [];
  int _selectedLevel = 3; // 默认等级3
  String? _userToken;
  bool _isSending = false;
  late String _markdownKey;
  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadUserToken();
    _markdownKey = 'initial key';
  }

  // 初始化数据
  void _initializeData() {
    if (widget.passageData is PassageEditRequest) {
      // 编辑模式
      _isEditMode = true;
      final editData = widget.passageData as PassageEditRequest;
      _titleController.text = editData.subject;
      _bodyController.text = editData.body;
      _tags = List.from(editData.filter);
      _selectedLevel = editData.level;
    } else if (widget.passageData is PassageCreateRequest) {
      // 创建模式（虽然通常传入的是空的PassageEditRequest）
      _isEditMode = false;
      final createData = widget.passageData as PassageCreateRequest;
      _titleController.text = createData.subject;
      _bodyController.text = createData.body;
      _tags = List.from(createData.filter);
      _selectedLevel = createData.level;
    } else {
      // 默认创建模式
      _isEditMode = false;
    }
  }

  // 加载用户token
  Future<void> _loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('token');
  }

  // 添加标签
  void _addTag() {
    final tagText = _tagController.text.trim();
    if (tagText.isNotEmpty && !_tags.contains(tagText) && _tags.length < 5) {
      setState(() {
        _tags.add(tagText);
        _tagController.clear();
      });
    }
  }

  // 删除标签
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // 获取等级文本
  String _getLevelText(int level) {
    switch (level) {
      case 0:
        return '仅自己可见';
      case 1:
        return '仅管理员和自己可见';
      case 2:
        return '仅所有作者、管理员和自己可见';
      case 3:
        return '所有访客、作者和管理员可见';
      default:
        return '未知等级';
    }
  }

  // 发送文章
  Future<void> _sendPassage() async {
    if (_userToken == null) {
      ToastUtil.showError('用户未登录');
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ToastUtil.showError('请输入文章标题');
      return;
    }

    if (_bodyController.text.trim().isEmpty) {
      ToastUtil.showError('请输入文章内容');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      String url;
      Map<String, dynamic> requestData;

      if (_isEditMode && widget.passageData is PassageEditRequest) {
        // 编辑文章
        url = baseUrl + passageEdit;
        final editRequest = PassageEditRequest(
          id: (widget.passageData as PassageEditRequest).id,
          token: _userToken!,
          subject: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          level: _selectedLevel,
          filter: _tags,
        );
        requestData = editRequest.toJson();
      } else {
        // 创建文章
        url = baseUrl + passageCreate;
        final createRequest = PassageCreateRequest(
          token: _userToken!,
          subject: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          level: _selectedLevel,
          filter: _tags,
        );
        requestData = createRequest.toJson();
      }

      Response response = await dio.post(url, data: requestData);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null) {
          final decodedData = jsonDecode(responseData);
          final msg = Msg.fromJson(decodedData);

          if (msg.msg == 'success' || msg.msg.contains('成功')) {
            ToastUtil.showSuccess(_isEditMode ? '文章更新成功' : '文章创建成功');
            // 返回上一页并刷新列表
            if (mounted) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            }
          } else {
            ToastUtil.showError(msg.msg);
          }
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        var data = e.response!.data;
        var msg = Msg.fromJson(jsonDecode(data));
        ToastUtil.showError(msg.msg);
      } else {
        ToastUtil.showError(e.message ?? '网络连接错误');
      }
    } catch (e) {
      ToastUtil.showError('操作失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 56),
                    // 标题输入框
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: '请输入文章标题',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Markdown编辑和预览区域
                    SizedBox(
                      height: 400, // 固定高度
                      child: Row(
                        children: [
                          // 左侧编辑区
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Markdown编辑',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _bodyController,
                                    maxLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                      hintText: '请输入文章内容（支持Markdown语法）',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: colorScheme.surfaceVariant
                                          .withOpacity(0.3),
                                    ),
                                    textAlignVertical: TextAlignVertical.top,
                                    onChanged: (value) {
                                      setState(() {}); // 触发预览更新
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 右侧预览区
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Markdown预览',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorScheme.outline.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorScheme.surfaceVariant
                                          .withOpacity(0.3),
                                    ),
                                    child: SingleChildScrollView(
                                      child: GptMarkdown(
                                        key: Key(_markdownKey),
                                        _bodyController.text.isEmpty
                                            ? '预览区域\n\n在左侧输入Markdown内容，这里会实时显示预览效果。'
                                            : _bodyController.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 标签和等级设置区域
                    SizedBox(
                      height: 200, // 固定高度
                      child: Row(
                        children: [
                          // 左侧标签设置
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '标签设置 (最多5个)',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _tagController,
                                        decoration: InputDecoration(
                                          hintText: '输入标签',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: colorScheme.surfaceVariant
                                              .withOpacity(0.3),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                        ),
                                        onSubmitted: (_) => _addTag(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _tags.length < 5
                                          ? _addTag
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        foregroundColor: colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: const Text('添加'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: _tags.map((tag) {
                                      return Chip(
                                        label: Text(tag),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 16,
                                        ),
                                        onDeleted: () => _removeTag(tag),
                                        backgroundColor:
                                            colorScheme.primaryContainer,
                                        labelStyle: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 右侧等级设置
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '文章等级',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Column(
                                    children: List.generate(4, (index) {
                                      return RadioListTile<int>(
                                        title: Text(
                                          _getLevelText(index),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        value: index,
                                        groupValue: _selectedLevel,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedLevel = value!;
                                          });
                                        },
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  // 构建左侧组件
  Widget _buildLeftWidget() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  // 构建中间组件
  Widget _buildCenterWidget() {
    return Text(
      _isEditMode ? '编辑文章' : '创建文章',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // 构建右侧组件
  Widget _buildRightWidget() {
    return Row(
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
              tooltip: themeManager.isDarkMode ? '切换到浅色主题' : '切换到深色主题',
            );
          },
        ),

        SizedBox(
          height: 35,
          width: 80,
          child: CustomButton(
            onPressed: () {
              _isSending ? null : _sendPassage();
            },
            text: '发送',
            isLoading: _isSending,
          ),
        ),
        SizedBox(width: 33),
      ],
    );
  }
}
