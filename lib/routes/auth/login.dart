import 'dart:convert';
import 'package:bello_front/request_model/auth/token_request.dart';
import 'package:flutter/material.dart';
import 'package:bello_front/request_model/auth/auth_login.dart';
import 'package:bello_front/request_model/auth/auth_profile.dart';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/util/user_manager.dart';
import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/global_value.dart';
import 'package:bello_front/route.dart';
import 'package:go_router/go_router.dart';
import 'package:bello_front/control/custom_text_field.dart';
import 'package:bello_front/control/custom_button.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController(); // 统一的账号输入控制器
  final _passwordController = TextEditingController();
  String _loginType = 'phone'; // 'phone' 或 'email'
  bool _isLoading = false; // 加载状态

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 获取并保存用户信息
  Future<void> _fetchAndSaveUserProfile(String token) async {
    try {
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
          }
        }
      }
    } catch (e) {
      // 获取用户信息失败不影响登录流程，只记录错误
      print('获取用户信息失败: $e');
    }
  }

  // 提交登录表单的函数
  Future<void> handleLogin(LoginRequest loginRequest) async {
    String url = baseUrl + loginRoute;

    try {
      // 发送 POST 请求
      Response response = await dio.post(
        url,
        data: loginRequest.toJson(), // 请求体数据
      );

      // 请求成功，响应状态码在 200 到 299 之间
      if (response.statusCode == 200) {
        // 解析返回的 JSON 数据
        final responseData = response.data;
        if (jsonDecode(responseData) != null) {
          var token = TokenRequest.fromJson(
            Map<String, dynamic>.from(jsonDecode(responseData)),
          );
          if (token.token != '') {
            // 保存token
            await UserManager.saveToken(token.token);

            // 获取并保存用户信息
            await _fetchAndSaveUserProfile(token.token);

            ToastUtil.showSuccess('登录成功');

            // 跳转到首页
            if (mounted) {
              context.go('/');
            }
          } else {
            ToastUtil.showError('未预期的错误');
          }
        }
      }
    } on DioException catch (e) {
      // 处理 Dio 错误，例如网络问题、超时等
      if (e.response != null) {
        // 服务器返回了错误响应，状态码不在 2xx 范围内
        if (e.response!.data != null) {
          var data = e.response!.data;
          var msg = Msg.fromJson(jsonDecode(data));
          ToastUtil.showError(msg.msg);
        } else {
          ToastUtil.showError('登录失败');
        }
      } else {
        // 请求设置或发送时出现错误，例如网络连接问题
        ToastUtil.showError(e.message ?? '网络连接错误');
      }
    } catch (e) {
      // 处理其他未知错误
      ToastUtil.showError('发生未知错误: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final loginRequest = LoginRequest(
          phoneNumber: _loginType == 'phone' ? _accountController.text : '',
          email: _loginType == 'email' ? _accountController.text : '',
          password: _passwordController.text,
        );
        await handleLogin(loginRequest);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 标题
                  Text(
                    '登录',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 登录方式选择
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _loginType,
                        isExpanded: true,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        dropdownColor: colorScheme.surface,
                        items: const [
                          DropdownMenuItem(
                            value: 'phone',
                            child: Text('手机号登录'),
                          ),
                          DropdownMenuItem(value: 'email', child: Text('邮箱登录')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _loginType = value;
                              _accountController.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 账号输入框
                  CustomTextField(
                    controller: _accountController,
                    label: _loginType == 'phone' ? '手机号' : '邮箱',
                    keyboardType: _loginType == 'phone'
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _loginType == 'phone' ? '请输入手机号' : '请输入邮箱';
                      }
                      if (_loginType == 'phone') {
                        if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                          return '请输入有效的手机号';
                        }
                      } else {
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return '请输入有效的邮箱地址';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // 密码输入框
                  CustomTextField(
                    controller: _passwordController,
                    label: '密码',
                    obscureText: true,
                    showObscureToggle: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      if (value.length < 6) {
                        return '密码长度至少6位';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // 登录按钮
                  CustomButton(
                    onPressed: _submitForm,
                    text: _isLoading ? '登录中...' : '登录',
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  // 注册链接
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '还没有账号？',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/auth/register');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '注册',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 隐私协议链接
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '登录即表示您同意我们的',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/passage/detail?id=1');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '《隐私协议》',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 返回首页链接
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      '返回首页',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
