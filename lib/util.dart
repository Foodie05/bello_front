import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

/// 主题状态管理器
/// 用于管理应用的明暗主题切换，默认为深色主题
class ThemeManager extends ChangeNotifier {
  // 私有变量，存储当前主题模式，默认为深色
  ThemeMode _themeMode = ThemeMode.dark;
  
  // 获取当前主题模式
  ThemeMode get themeMode => _themeMode;
  
  // 获取当前是否为深色主题
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // 切换主题
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  
  // 设置为浅色主题
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
  
  // 设置为深色主题
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
  
  // 设置为系统主题
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
