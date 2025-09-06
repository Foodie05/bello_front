import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bello_front/model/user_profile.dart';

/// 用户信息管理工具类
/// 统一处理UserProfile的存储和读取
class UserManager {
  static const String _profileKey = 'profile';
  static const String _tokenKey = 'token';
  
  /// 保存用户信息到SharedPreferences
  static Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(userProfile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      print('保存用户信息失败: $e');
    }
  }
  
  /// 从SharedPreferences读取用户信息
  static Future<UserProfile?> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null && profileJson.isNotEmpty) {
        final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
        return UserProfile.fromJson(profileMap);
      }
    } catch (e) {
      print('读取用户信息失败: $e');
    }
    return null;
  }
  
  /// 清除用户信息
  static Future<void> clearUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      print('清除用户信息失败: $e');
    }
  }
  
  /// 保存用户token
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('保存token失败: $e');
    }
  }
  
  /// 获取用户token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('获取token失败: $e');
      return null;
    }
  }
  
  /// 清除用户token
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('清除token失败: $e');
    }
  }
  
  /// 清除所有用户数据
  static Future<void> clearAllUserData() async {
    await clearUserProfile();
    await clearToken();
  }
  
  /// 检查用户是否已登录
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}