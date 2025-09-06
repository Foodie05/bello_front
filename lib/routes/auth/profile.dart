import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/request_model/auth/auth_profile.dart';
import 'package:bello_front/request_model/auth/auth_logout.dart';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:bello_front/global_value.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/control/custom_button.dart';
import 'package:bello_front/widgets/invitation_management_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isLoggingOut = false;
  int _selectedIndex = 0; // 0: 基本信息, 1: 邀请码管理

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // 加载用户个人信息
  Future<void> _loadUserProfile() async {
    try {
      final token = await UserManager.getToken();

      if (token == null || token.isEmpty) {
        ToastUtil.showInfo('请先登录');
        if (mounted) {
          context.go('/auth/login');
        }
        return;
      }

      final profileRequest = ProfileRequest(token: token);
      String url = baseUrl + profileRoute;

      Response response = await dio.post(url, data: profileRequest.toJson());

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (jsonDecode(responseData) != null) {
          final decodedData = jsonDecode(responseData);
          if (decodedData is Map<String, dynamic>) {
            final userProfile = UserProfile.fromJson(decodedData);
            // 保存用户信息到SharedPreferences
            await UserManager.saveUserProfile(userProfile);
            setState(() {
              _userProfile = userProfile;
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
      ToastUtil.showError('加载用户信息失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 退出登录
  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final token = await UserManager.getToken();

      if (token != null && token.isNotEmpty) {
        final logoutRequest = LogoutRequest(token: token);
        String url = baseUrl + logoutRoute;

        Response response = await dio.post(url, data: logoutRequest.toJson());

        if (response.statusCode == 200) {
          // 清除本地存储的用户信息
          await UserManager.clearAllUserData();

          ToastUtil.showSuccess('退出登录成功');

          if (mounted) {
            context.go('/auth/login');
          }
        }
      } else {
        // 如果没有token，直接清除本地数据并跳转
        await UserManager.clearAllUserData();
        if (mounted) {
          context.go('/auth/login');
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
      ToastUtil.showError('退出登录失败: $e');
    } finally {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  // 构建头像
  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: _userProfile?.avatar != null && _userProfile!.avatar.isNotEmpty
            ? Image.memory(
                base64Decode(_userProfile!.avatar),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              )
            : Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
      ),
    );
  }

  // 构建信息项
  Widget _buildInfoItem(String label, String value, {IconData? icon}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '未设置' : value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 获取用户等级文本
  String _getUserLevelText(int level) {
    switch (level) {
      case 1:
        return '管理员';
      case 2:
        return '荣誉作者';
      case 3:
        return '访客';
      case 4:
        return '黑名单';
      default:
        return '未知等级';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          '个人简介',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // 左侧目录
                Container(
                  width: 150,
                  color: colorScheme.surface,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: _selectedIndex == 0
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                        title: const Text('基本信息'),
                        selected: _selectedIndex == 0,
                        selectedTileColor: colorScheme.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      if (_userProfile?.level == 1)
                        ListTile(
                          leading: Icon(
                            Icons.card_giftcard,
                            color: _selectedIndex == 1
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                          title: const Text('邀请码'),
                          selected: _selectedIndex == 1,
                          selectedTileColor: colorScheme.primary.withOpacity(
                            0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                // 右侧内容
                Expanded(
                  child: _selectedIndex == 0
                      ? _buildBasicInfoPage()
                      : _buildInvitationPage(),
                ),
              ],
            ),
    );
  }

  // 构建基本信息页面
  Widget _buildBasicInfoPage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像和基本信息
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    Text(
                      _userProfile?.nickname ?? '未设置昵称',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getUserLevelText(_userProfile?.level ?? 3),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 详细信息
              Text(
                '详细信息',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoItem(
                '用户ID',
                _userProfile?.id.toString() ?? '0',
                icon: Icons.badge,
              ),

              _buildInfoItem(
                '手机号',
                _userProfile?.phoneNumber ?? '',
                icon: Icons.phone,
              ),

              _buildInfoItem(
                '邮箱',
                _userProfile?.email ?? '',
                icon: Icons.email,
              ),

              _buildInfoItem(
                '个人签名',
                _userProfile?.slogan ?? '',
                icon: Icons.format_quote,
              ),

              const SizedBox(height: 32),

              // 退出登录按钮
              Center(
                child: CustomButton(
                  onPressed: _logout,
                  text: _isLoggingOut ? '退出中...' : '退出登录',
                  isLoading: _isLoggingOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建邀请码管理页面
  Widget _buildInvitationPage() {
    return InvitationManagementPage(userProfile: _userProfile!);
  }
}
