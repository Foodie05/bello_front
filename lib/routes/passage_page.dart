import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:bello_front/model/passage.dart';
import 'package:bello_front/request_model/passage/passage_search.dart';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/request_model/auth/token_request.dart';
import 'package:bello_front/control/passage_item.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/util/user_manager.dart';
import '../request_model/passage/passage_create.dart';

class PassagePage extends StatefulWidget {
  const PassagePage({super.key});

  @override
  State<PassagePage> createState() => PassagePageState();
}

class PassagePageState extends State<PassagePage> {
  final Dio dio = Dio();
  List<Passage> _passages = [];
  bool _isLoading = true;
  String? _userToken;
  int? _userLevel;
  String _currentKeyword = '';
  String _currentSearchType = 'keyword'; // 'keyword', 'author', 'label'
  List<String> _availableLabels = [];
  String? _selectedLabel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadLabels();
    _loadPassages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 加载用户信息
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('token');
    final userProfile = await UserManager.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _userLevel = userProfile.level;
      });
    }
  }

  // 设置搜索类型
  void setSearchType(String searchType) {
    setState(() {
      _currentSearchType = searchType;
      _selectedLabel = null; // 清除标签选择
    });
  }

  // 搜索文章
  Future<void> searchPassages(String keyword) async {
    setState(() {
      _isLoading = true;
      _currentKeyword = keyword;
    });
    await _loadPassages();
  }

  // 加载标签列表
  Future<void> _loadLabels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token != null && token.isNotEmpty) {
        final tokenRequest = TokenRequest(token: token);
        final response = await dio.post(
          baseUrl + passageLabel,
          data: tokenRequest.toJson(),
        );
        
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData != null) {
            final List<dynamic> labelList = jsonDecode(responseData);
            setState(() {
              _availableLabels = labelList.cast<String>();
            });
          }
        }
      }
    } catch (e) {
      print('加载标签失败: $e');
    }
  }

  // 加载文章列表
  Future<void> _loadPassages() async {
    try {
      // 检查用户token
      final prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString('token');
      
      // 构建搜索请求
      PassageSearchRequest searchRequest;
      
      if (_selectedLabel != null) {
        // 标签搜索
        searchRequest = PassageSearchRequest(
          token: _userToken ?? '',
          nickname: '',
          keyword: '',
          filter: [_selectedLabel!],
        );
      } else {
        // 根据搜索类型构建请求
        switch (_currentSearchType) {
          case 'author':
            searchRequest = PassageSearchRequest(
              token: _userToken ?? '',
              nickname: _currentKeyword,
              keyword: '',
              filter: [],
            );
            break;
          case 'label':
            searchRequest = PassageSearchRequest(
              token: _userToken ?? '',
              nickname: '',
              keyword: '',
              filter: _currentKeyword.isEmpty ? [] : [_currentKeyword],
            );
            break;
          default: // keyword
            searchRequest = PassageSearchRequest(
              token: _userToken ?? '',
              nickname: '',
              keyword: _currentKeyword,
              filter: [],
            );
        }
      }
      
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

  // 构建标签选择组件
  Widget _buildLabelSelector() {
    if (_availableLabels.isEmpty) {
      return const SizedBox();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            '标签筛选：',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String?>(
                focusColor: Colors.transparent,
                value: _selectedLabel,
                hint: const Text('选择标签'),
                underline: const SizedBox(),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('全部标签'),
                  ),
                  ..._availableLabels.map((label) => DropdownMenuItem<String?>(
                    value: label,
                    child: Text(label),
                  )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLabel = value;
                    _searchController.clear();
                    _currentKeyword = '';
                  });
                  _loadPassages();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 创建新文章
  void _createNewPassage() {
    // 检查权限
    if (_userToken == null) {
      ToastUtil.showError('请先登录');
      return;
    }
    
    if (_userLevel == null || (_userLevel != 1 && _userLevel != 2)) {
      ToastUtil.showError('权限不足，只有管理员和作者可以创建文章');
      return;
    }

    // 创建空的PassageEditRequest用于新建文章
    final emptyPassage = PassageCreateRequest(
      token: _userToken!,
      subject: '',
      body: '',
      level: 3, // 默认等级
      filter: [],
    );

    // 跳转到编辑页面
    context.push('/passage/edit', extra: emptyPassage).then((_) {
      // 返回时刷新文章列表
      _loadPassages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // 主要内容区域
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 页面标题
                  Text(
                    '所有文章',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 标签选择器
                  _buildLabelSelector(),
                  const SizedBox(height: 16),
                  
                  // 文章列表
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _passages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              )
                            : ListView.builder(
                                itemCount: _passages.length,
                                itemBuilder: (context, index) {
                                  final passage = _passages[index];
                                  return PassageItem(
                                    passage: passage,
                                    onTap: () {
                                      context.push(
                                        '/passage/detail?id=${passage.id}',
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // 新建按钮
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 4,bottom: 22),
        child:  FloatingActionButton(
          onPressed: _createNewPassage,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}
