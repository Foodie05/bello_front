import 'dart:convert';
import 'package:bello_front/control/custom_button.dart';
import 'package:bello_front/request_model/mgr/mgr_invite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:bello_front/model/user_profile.dart';
import 'package:bello_front/model/invitation_pool.dart';
import 'package:bello_front/request_model/auth/token_request.dart';
import 'package:bello_front/request_model/mgr/mgr_delete_invite.dart';
import 'package:bello_front/route.dart';
import 'package:bello_front/global_value.dart';
import 'package:bello_front/util/toast_util.dart';
import 'package:bello_front/util/user_manager.dart';

class InvitationManagementPage extends StatefulWidget {
  final UserProfile userProfile;
  
  const InvitationManagementPage({
    super.key,
    required this.userProfile,
  });
  
  @override
  State<InvitationManagementPage> createState() => _InvitationManagementPageState();
}

class _InvitationManagementPageState extends State<InvitationManagementPage> {
  List<InvitationPool> _invitations = [];
  bool _isLoading = false;
  bool _isCreating = false;
  
  // 获取等级文本
  String _getLevelText(int level) {
    switch (level) {
      case 1:
        return '管理员';
      case 2:
        return '作者';
      case 3:
        return '访客';
      case 4:
        return '黑名单';
      default:
        return '未知';
    }
  }
  
  // 获取等级颜色
  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
  
  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }
  
  // 加载邀请码列表
  Future<void> _loadInvitations() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final token = await UserManager.getToken();
      if (token == null || token.isEmpty) {
        ToastUtil.showError('请先登录');
        return;
      }
      
      final request = TokenRequest(token: token);
      final response = await dio.post(
        baseUrl + invitationListRoute,
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        try {
          final List<dynamic> jsonList = jsonDecode(responseData);
          final List<InvitationPool> invitations = jsonList
              .map((json) => InvitationPool.fromJson(jsonDecode(json)))
              .toList();
          
          setState(() {
            _invitations = invitations;
            _isLoading = false;
          });
        } catch (e) {
          ToastUtil.showError('数据解析失败: $e');
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on DioException catch (e) {
      ToastUtil.showError('加载邀请码失败: ${e.message}');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastUtil.showError('加载邀请码失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // 复制邀请码到剪贴板
  Future<void> _copyInvitationCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    ToastUtil.showSuccess('邀请码已复制到剪贴板');
  }
  
  // 删除邀请码
  Future<void> _deleteInvitation(String code) async {
    try {
      final token = await UserManager.getToken();
      if (token == null || token.isEmpty) {
        ToastUtil.showError('请先登录');
        return;
      }
      
      final request = DeleteInviteRequest(token: token, code: code);
      final response = await dio.post(
        baseUrl + invitationDeleteRoute,
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        ToastUtil.showSuccess('删除成功');
        _loadInvitations(); // 重新加载列表
      }
    } on DioException catch (e) {
      ToastUtil.showError('删除失败: ${e.message}');
    } catch (e) {
      ToastUtil.showError('删除失败: $e');
    }
  }
  
  // 创建新邀请码
  Future<void> _createInvitation(int level) async {
    setState(() {
      _isCreating = true;
    });
    
    try {
      final token = await UserManager.getToken();
      if (token == null || token.isEmpty) {
        ToastUtil.showError('请先登录');
        return;
      }
      
      final request = InviteRequest(token: token, level: level);
      final response = await dio.post(
        baseUrl + invitationCreateRoute,
        data: request.toJson(),
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        final invitationCode = jsonDecode(responseData)['code'];
        
        // 复制邀请码到剪贴板
        await Clipboard.setData(ClipboardData(text: invitationCode));
        
        ToastUtil.showSuccess('邀请码创建成功并已复制到剪贴板');
        _loadInvitations(); // 重新加载列表
      }
    } on DioException catch (e) {
      ToastUtil.showError('创建失败: ${e.message}');
    } catch (e) {
      ToastUtil.showError('创建失败: $e');
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }
  
  // 显示创建邀请码对话框
  void _showCreateInvitationDialog() {
    int selectedLevel = 3; // 默认普通用户
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('创建邀请码'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('请选择邀请码等级：'),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedLevel,
                    decoration: const InputDecoration(
                      labelText: '用户等级',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('管理员')),
                      DropdownMenuItem(value: 2, child: Text('作者')),
                      DropdownMenuItem(value: 3, child: Text('访客')),
                      DropdownMenuItem(value: 4, child: Text('黑名单')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedLevel = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: _isCreating
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _createInvitation(selectedLevel);
                        },
                  child: _isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和创建按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '邀请码管理',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 42,
                width: 135,
                child: CustomButton(
                    onPressed: (){
                      _isCreating ? null : _showCreateInvitationDialog();
                    },
                    text: _isCreating ? '创建中...' : '+ 创建邀请码'
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // 邀请码表格
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_invitations.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '暂无邀请码',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            )
          else
            _buildInvitationTable(),
        ],
      ),
    );
  }
  
  // 构建邀请码表格
  Widget _buildInvitationTable() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    '序号',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '邀请码',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '等级',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    '操作',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          // 表格内容
          ...List.generate(_invitations.length, (index) {
            final invitation = _invitations[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: index < _invitations.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      invitation.invitationCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      _getLevelText(invitation.level),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getLevelColor(invitation.level),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => _copyInvitationCode(invitation.invitationCode),
                          child: const Text('复制'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _deleteInvitation(invitation.invitationCode),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('删除'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}