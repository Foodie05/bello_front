import 'dart:convert';
import 'dart:typed_data';
import 'package:bello_front/widgets/side_widgets/icp_info.dart';
import 'package:bello_front/widgets/side_widgets/visit_time.dart';
import 'package:bello_front/widgets/banner/animated_gradient_banner.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:bello_front/model/passage.dart';
import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/request_model/passage/passage_search.dart';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/control/passage_item.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:bello_front/global_value.dart';
import 'package:bello_front/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Passage> _passages = [];
  bool _isLoading = true;
  String? _userToken;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadPassages();
    _loadUserInfo();
  }

  // 加载用户信息
  Future<void> _loadUserInfo() async {
    try {
      final token = await UserManager.getToken();
      final userProfile = await UserManager.getUserProfile();
      if (mounted) {
        setState(() {
          _userToken = token;
          _userProfile = userProfile;
        });
      }
    } catch (e) {
      // 忽略错误，用户可能未登录
    }
  }

  // 处理Banner按钮点击事件
  void _handleButtonPress() {
    context.go('/passage/detail?id=2');
  }

  // 加载文章列表
  Future<void> _loadPassages() async {
    try {
      // 检查用户token
      final prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('token');
      
      // 构建搜索请求
      final searchRequest = PassageSearchRequest(
        token: _userToken ?? '',
        nickname: '',
        keyword: '',
        filter: [],
      );
      
      String url = baseUrl + passageSearch;
      
      Response response = await dio.post(
        url,
        data: searchRequest.toJson(),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null) {
          // 解析返回的List<Passage>
          final decodedData = jsonDecode(responseData);
          if (decodedData is List) {
            final passages = decodedData
                .map((item) => Passage.fromJson(jsonDecode(item)))
                .toList();
            setState(() {
              _passages = passages;
              _isLoading = false;
            });
          } else {
            setState(() {
              _passages = [];
              _isLoading = false;
            });
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
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastUtil.showError('加载文章失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 构建Banner组件
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedGradientBanner(
        title: '欢迎来到云鲸岛博客站',
        subtitle: 'Hope, Stream, Love❤️',
        height: 300,
        onTap: () {
          context.go('/passage/detail?id=2');
        },
        buttonText: '了解本站',
        onButtonPressed: _handleButtonPress,
      ),
    );
  }

  // 构建用户头像
  Widget _buildUserAvatar(ColorScheme colorScheme) {
    if (_userProfile?.avatar != null && _userProfile!.avatar.isNotEmpty) {
      try {
        final Uint8List avatarBytes = base64Decode(_userProfile!.avatar);
        return CircleAvatar(
          radius: 20,
          backgroundImage: MemoryImage(avatarBytes),
        );
      } catch (e) {
        // 如果头像数据有问题，显示默认头像
      }
    }
    
    return CircleAvatar(
      radius: 20,
      backgroundColor: colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        color: colorScheme.primary,
      ),
    );
  }

  // 构建右侧小组件区域
  Widget _buildSideWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      width: isMobile ? double.infinity : 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息卡片
          GestureDetector(
            onTap:  _userToken == null ? () {
              context.go('/auth/login');
            } : (){
              context.push('/auth/profile');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildUserAvatar(colorScheme),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userProfile?.nickname ?? (_userToken != null ? '已登录用户' : '游客'),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _userToken != null ? '欢迎回来' : '欢迎登录',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _userToken == null
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                decoration: _userToken == null
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          VisitTime(),
          const SizedBox(height: 16),
          IcpInfo()
          // 热门标签
          /*Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '热门标签',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['技术', '生活', '思考', '分享', '学习'].map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768; // 小于768px认为是手机端
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: ListView(
        children: [
          // Banner区域
          _buildBanner(),
          
          // 主要内容区域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isMobile
                ? // 手机端布局：只显示右侧小组件
                Column(
                    children: [
                      _buildSideWidget(),
                    ],
                  )
                : // 桌面端布局：显示文章列表和右侧小组件
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左栏：文章列表
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '最新文章',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            _isLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : _passages.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.article_outlined,
                                                size: 64,
                                                color: colorScheme.onSurfaceVariant,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                '暂无文章',
                                                style: theme.textTheme.bodyLarge?.copyWith(
                                                  color: colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: _passages.map((passage) {
                                          return PassageItem(
                                            passage: passage,
                                            onTap: () {
                                              context.push('/passage/detail?id=${passage.id}');
                                            },
                                          );
                                        }).toList(),
                                      ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      // 右栏：小组件
                      _buildSideWidget(),
                    ],
                  ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
