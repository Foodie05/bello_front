import 'package:bello_front/global_value.dart';
import 'package:bello_front/pages/root_page.dart';
import 'package:bello_front/pages/unknown_page.dart';
import 'package:bello_front/routes/auth/login.dart';
import 'package:bello_front/routes/auth/profile.dart';
import 'package:bello_front/routes/auth/register.dart';
import 'package:bello_front/routes/passage/passage_edit_page.dart';
import 'package:bello_front/routes/passage/passage_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:toastification/toastification.dart';
import 'util.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dio = Dio();
  // 设置URL策略，移除URL中的#号
  usePathUrlStrategy();
  runApp(
    ChangeNotifierProvider(create: (context) => ThemeManager(), child: MyApp()),
  );
}

// 使用 GoRouter 管理路由
final GoRouter _router = GoRouter(
  // 定义所有路由
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RootPage();
      },
    ),
    GoRoute(
      path: '/auth/login',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/auth/register',
      builder: (BuildContext context, GoRouterState state) {
        return const Register();
      },
    ),
    GoRoute(
      path: '/auth/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const Profile();
      },
    ),
    GoRoute(
      path: '/passage/edit',
      builder: (BuildContext context, GoRouterState state) {
        final passageData = state.extra;
        return PassageEditPage(passageData: passageData);
      },
    ),
    GoRoute(
      path: '/passage/detail',
      builder: (BuildContext context, GoRouterState state) {
        final passageId = state.uri.queryParameters['id'] ?? '';
        return PassageDetailPage(passageId: passageId);
      },
    ),
  ],
  // 404 页面处理
  errorBuilder: (context, state) => UnknownPage(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        TextTheme textTheme = createTextTheme(context, "Ubuntu", "Ubuntu");
        MaterialTheme theme = MaterialTheme(textTheme);
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: '云鲸岛的博客站',
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: themeManager.themeMode,
            routerConfig: _router,
          ),
        );
      },
    );
  }
}

// Note: MyHomePage is not used directly in the app's routing anymore.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主题切换演示'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<ThemeManager>(
              builder: (context, themeManager, child) {
                return Column(
                  children: [
                    Text(
                      '当前主题: ${themeManager.isDarkMode ? "深色" : "浅色"}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: themeManager.toggleTheme,
                      child: Text(
                        themeManager.isDarkMode ? '切换到浅色主题' : '切换到深色主题',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: themeManager.setLightTheme,
                          child: const Text('浅色主题'),
                        ),
                        ElevatedButton(
                          onPressed: themeManager.setDarkTheme,
                          child: const Text('深色主题'),
                        ),
                        ElevatedButton(
                          onPressed: themeManager.setSystemTheme,
                          child: const Text('系统主题'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
