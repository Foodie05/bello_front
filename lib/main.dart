import 'package:cw_blog/frame/profile_mgr.dart';
import 'package:cw_blog/frame/root_page.dart';
import 'package:cw_blog/frame/theme.dart';
import 'package:cw_blog/widgets/short_link.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await initProfileBox();
  runApp(ChangeNotifierProvider(
    create: (_)=>ThemeSwitch(),
    child: const MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeSwitch>(builder:(context,themeSwitch,child){
      return MaterialApp(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final uri = Uri.parse(settings.name ?? '/');
          print(uri);
          if (uri.pathSegments[0] == 's') {

            final shortCode = uri.queryParameters['s'];
            print('come here,shortCode=$shortCode');
            //redirect to new page, if invalid, goto homepage
            if(shortCode==null){
              html.window.location.href = 'https://cruty.cn';
            }
            redirectPage(shortCode!);
          }
          return null; // 返回 null 表示没有匹配的路由
        },
        theme: themeSwitch.isDark==true?const MaterialTheme().dark():const MaterialTheme().light(),
        home: const RootPage(),
      );
    });
  }
}
