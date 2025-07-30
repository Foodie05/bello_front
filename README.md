# CW Blog (CloudWhale Blog)

一个基于 Flutter 开发的现代化博客平台，支持多平台部署，集成了文章管理、短链接服务和用户系统。

## 📖 项目简介

CW Blog 是一个功能完整的博客平台，采用 Flutter 框架开发，支持 Web、移动端和桌面端。项目提供了直观的用户界面，支持 Markdown 文章编辑、主题切换、短链接生成等功能，是个人博客或团队内容管理的理想选择。

## ✨ 功能特性

### 核心功能
- 📝 **文章管理**：支持 Markdown 格式的文章创建、编辑和发布
- 🔍 **文章搜索**：智能搜索功能，快速定位目标内容
- 🏷️ **标签系统**：灵活的文章分类和标签管理
- 👤 **用户系统**：完整的用户注册、登录和个人资料管理

### 特色功能
- 🔗 **短链接服务**：内置 URL 缩短功能，支持自定义短码和过期时间
- 🌓 **主题切换**：支持明暗主题切换，提供舒适的阅读体验
- 📱 **响应式设计**：适配多种屏幕尺寸，完美支持移动端和桌面端
- 🚀 **多平台支持**：一套代码，支持 Web、iOS、Android、Windows、macOS、Linux

### 用户体验
- 🎨 **Material Design 3**：采用最新的 Material Design 设计规范
- ⚡ **快速加载**：优化的性能，提供流畅的用户体验
- 🔄 **实时预览**：Markdown 编辑器支持实时预览
- 📊 **访问统计**：内置访问量统计功能

## 🛠️ 技术实现

### 技术栈
- **前端框架**：Flutter 3.5.4+
- **状态管理**：Provider
- **本地存储**：Hive
- **网络请求**：HTTP
- **Markdown 渲染**：markdown_widget
- **主题系统**：Material Design 3

### 核心依赖
```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.2          # 状态管理
  http: ^1.2.2              # 网络请求
  hive: ^2.2.3              # 本地数据库
  hive_flutter: ^1.1.0      # Hive Flutter 支持
  path_provider: ^2.1.5     # 路径管理
  url_launcher: ^6.3.1      # URL 启动器
  markdown_widget: ^2.3.2+6 # Markdown 渲染
  flutter_toastr: ^1.0.3    # 消息提示
  crypto: ^3.0.6            # 加密功能
```

### 项目结构
```
lib/
├── main.dart              # 应用入口
├── frame/                 # 框架层
│   ├── root_page.dart     # 根页面
│   ├── theme.dart         # 主题管理
│   ├── profile_mgr.dart   # 配置管理
│   └── value.dart         # 全局变量
├── pages/                 # 页面层
│   ├── home_page.dart     # 首页
│   ├── article_edit.dart  # 文章编辑
│   ├── passage_page.dart  # 文章列表
│   ├── user_page.dart     # 用户页面
│   └── goto_article.dart  # 文章详情
├── widgets/               # 组件层
│   ├── articles.dart      # 文章组件
│   ├── short_link.dart    # 短链接组件
│   ├── welcome_board.dart # 欢迎板块
│   └── ...
└── child_page/            # 子页面
    ├── account/           # 账户相关
    └── article/           # 文章相关
```

### 核心功能实现

#### 1. 文章管理系统
- 使用 `ArticleDataStruct` 管理文章数据结构
- 支持 Markdown 格式编辑和实时预览
- 集成标签系统，支持文章分类
- HTTP API 与后端服务通信

#### 2. 短链接服务
- 自定义短码生成算法
- 支持过期时间设置
- URL 重定向机制
- 本地缓存优化

#### 3. 主题系统
- 基于 Provider 的主题状态管理
- Material Design 3 色彩系统
- 明暗主题无缝切换
- 用户偏好持久化存储

#### 4. 路由系统
- 自定义路由处理
- 短链接重定向支持
- Web 友好的 URL 策略

## 🚀 快速开始

### 环境要求
- Flutter SDK 3.5.4 或更高版本
- Dart SDK 3.0 或更高版本
- 支持的平台：Web、iOS、Android、Windows、macOS、Linux

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd bello_front
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行项目**
   ```bash
   # Web 平台
   flutter run -d chrome
   
   # 移动端（需要连接设备或启动模拟器）
   flutter run
   
   # 桌面端
   flutter run -d windows  # Windows
   flutter run -d macos    # macOS
   flutter run -d linux    # Linux
   ```

### 配置说明

1. **后端 API 配置**
   - 在 `lib/frame/value.dart` 中配置后端 API 地址
   - 确保后端服务正常运行

2. **本地存储初始化**
   - 应用首次启动会自动初始化 Hive 数据库
   - 用户配置和缓存数据将存储在本地

## 📦 部署指南

### Web 部署

1. **构建 Web 版本**
   ```bash
   flutter build web --release
   ```

2. **部署到服务器**
   ```bash
   # 将 build/web 目录下的文件部署到 Web 服务器
   cp -r build/web/* /var/www/html/
   ```

### 移动端部署

1. **Android APK**
   ```bash
   flutter build apk --release
   ```

2. **iOS IPA**
   ```bash
   flutter build ios --release
   ```

### 桌面端部署

1. **Windows**
   ```bash
   flutter build windows --release
   ```

2. **macOS**
   ```bash
   flutter build macos --release
   ```

3. **Linux**
   ```bash
   flutter build linux --release
   ```

## 🔧 开发指南

### 代码规范
- 遵循 Dart 官方代码规范
- 使用 `analysis_options.yaml` 进行代码检查
- 组件化开发，保持代码模块化

### 状态管理
- 使用 Provider 进行全局状态管理
- 页面级状态使用 StatefulWidget
- 数据持久化使用 Hive

### API 集成
- 所有 API 请求统一使用 HTTP 包
- 错误处理和加载状态管理
- 数据模型使用 JSON 序列化

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request



## 🙏 致谢

感谢所有为本项目做出贡献的开发者和 Flutter 社区的支持。

---

**CW Blog** - 让内容创作更简单 ✨
