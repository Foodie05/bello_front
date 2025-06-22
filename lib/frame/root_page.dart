import 'package:cw_blog/frame/profile_mgr.dart';
import 'package:cw_blog/frame/theme.dart';
import 'package:cw_blog/pages/home_page.dart';
import 'package:cw_blog/pages/passage_page.dart';
import 'package:cw_blog/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _tabIndex = 0;
  List<Widget> pages=[
    HomePage(),
    PassagePage(),
    UserPage(),
  ];
  void onSwitchIndex(int newIndex) {
    setState(() {
      _tabIndex = newIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        child:Row(
          children: [
            NavigationRail(
              leading: IconButton(
                  onPressed: (){
                    context.read<ThemeSwitch>().switchTheme();
                  },
                  icon: Icon(ThemeSwitch().isDark==true?Icons.dark_mode_rounded:Icons.light_mode_rounded)
              ),
              selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
              selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
              unselectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              labelType: NavigationRailLabelType.selected,
              groupAlignment: 0,
              destinations: [
                NavigationRailDestination(selectedIcon:Icon(Icons.home),icon: Icon(Icons.home_outlined), label: Text('首页',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),)),
                NavigationRailDestination(selectedIcon: Icon(Icons.article), icon:Icon(Icons.article_outlined),label: Text('文章',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),)),
                NavigationRailDestination(selectedIcon: Icon(Icons.person_rounded),icon: Icon(Icons.person_outline_rounded), label: Text('我的',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer))),
              ],
              selectedIndex: _tabIndex,
              onDestinationSelected: (int newIndex){
                  onSwitchIndex(newIndex);
              }
            ),
            pages[_tabIndex]
          ],
        )
      )
    );
  }
}
