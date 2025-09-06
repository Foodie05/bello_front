import 'dart:convert';
import 'dart:typed_data';
import 'package:bello_front/request_model/msg.dart';
import 'package:bello_front/request_model/auth/auth_login.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bello_front/request_model/auth/auth_register.dart';
import 'package:bello_front/control/custom_text_field.dart';
import 'package:bello_front/control/custom_button.dart';
import 'package:bello_front/control/avatar_picker.dart';
import 'package:go_router/go_router.dart';
import '../../global_value.dart';
import '../../model/user_profile.dart';
import '../../request_model/auth/auth_profile.dart';
import '../../request_model/auth/token_request.dart';
import '../../util/user_manager.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _invitationController = TextEditingController();
  final _sloganController = TextEditingController();
  Uint8List? _avatarBytes;
  String? _avatarError;
  bool _isLoading = false; // 加载状态

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _invitationController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  // 提交注册表单的函数，留给用户实现具体逻辑
  Future<void> handleRegister(RegisterRequest registerRequest) async {
    String url = baseUrl+registerRoute;

    try {
      // 发送 POST 请求
      Response response = await dio.post(
        url,
        data: registerRequest.toJson(), // 请求体数据
      );

      // 请求成功，响应状态码在 200 到 299 之间
      if (response.statusCode == 200) {

        // 解析返回的 JSON 数据
        final responseData = jsonDecode(response.data);
        if (responseData!=null) {
          var msg=Msg.fromJson(responseData);
          if(msg.msg=='success'){
            ToastUtil.showSuccess('注册成功');
            // 注册成功后自动登录
            await _autoLogin();
          }else{
            ToastUtil.showError(msg.msg);
          }
        }
      }
    } on DioException catch (e) {
      // 处理 Dio 错误，例如网络问题、超时等
      if (e.response != null) {
        // 服务器返回了错误响应，状态码不在 2xx 范围内
        if(e.response!.data!=null){
          var data=e.response!.data;
          var msg=Msg.fromJson(jsonDecode(data));
          ToastUtil.showError(msg.msg);
        }else{
          ToastUtil.showError('发生了一个错误');
        }
      } else {
        // 请求设置或发送时出现错误，例如网络连接问题
        ToastUtil.showError(e.message ?? '网络连接错误');
        print('请求出错: ${e.message}');
      }
    } catch (e) {
      // 处理其他未知错误
      ToastUtil.showError('发生未知错误: $e');
      print('发生未知错误: $e');
    }
  }

  // 自动登录方法
  Future<void> _autoLogin() async {
    try {
      final loginRequest = LoginRequest(
        phoneNumber: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      String url = baseUrl + loginRoute;
      Response response = await dio.post(
        url,
        data: loginRequest.toJson(),
      );

      // 获取并保存用户信息
      Future<void> _fetchAndSaveUserProfile(String token) async {
        try {
          final profileRequest = ProfileRequest(token: token);
          String url = baseUrl + profileRoute;

          Response response = await dio.post(
            url,
            data: profileRequest.toJson(),
          );

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

      if (response.statusCode == 200) {
        // 解析返回的 JSON 数据
        final responseData = response.data;
        if (jsonDecode(responseData)!=null) {
          var token = TokenRequest.fromJson(Map<String, dynamic>.from(jsonDecode(responseData)));
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
    } catch (e) {
      // 自动登录失败，不显示错误，让用户手动登录
      print('自动登录失败: $e');
    }
  }

  void _submitForm() async {
    setState(() {
      _avatarError = _avatarBytes == null ? '请选择头像' : null;
    });

    if (_formKey.currentState!.validate() && _avatarError == null && !_isLoading) {
       setState(() {
         _isLoading = true;
       });
       
       try {
         final registerRequest = RegisterRequest(
           phoneNumber: _phoneController.text,
           email: _emailController.text,
           password: _passwordController.text,
           nickname: _nicknameController.text,
           invitation: _invitationController.text,
           avatar: base64Encode(_avatarBytes!),
           slogan: _sloganController.text,
         );
         await handleRegister(registerRequest);
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
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '注册',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: AvatarPicker(
                      onImageSelected: (bytes) {
                        setState(() {
                          _avatarBytes = bytes;
                          _avatarError = null;
                        });
                      },
                      errorText: _avatarError,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _phoneController,
                    label: '手机号',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入手机号';
                      }
                      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                        return '请输入有效的手机号';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _emailController,
                    label: '邮箱',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入邮箱';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return '请输入有效的邮箱地址';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _nicknameController,
                    label: '昵称',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入昵称';
                      }
                      if (value.length < 2) {
                        return '昵称长度至少2位';
                      }
                      if (value.length > 20) {
                        return '昵称长度不能超过20位';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _passwordController,
                    label: '密码',
                    obscureText: true,
                    showObscureToggle: true, // 启用切换功能
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
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: '确认密码',
                    obscureText: true,
                    showObscureToggle: true, // 启用切换功能
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请确认密码';
                      }
                      if (value != _passwordController.text) {
                        return '两次输入的密码不一致';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _invitationController,
                    label: '邀请码',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入邀请码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _sloganController,
                    label: '个人签名（可选）',
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 100) {
                        return '个人签名不能超过100字';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    onPressed: _submitForm,
                    text: _isLoading ? '注册中...' : '注册',
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '已有账号？',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/auth/login');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '登录',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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