import 'package:cw_blog/child_page/account/account_data_struct.dart';
import 'package:cw_blog/child_page/account/login.dart';
import 'package:cw_blog/frame/regulars.dart';
import 'package:cw_blog/widgets/about.dart';
import 'package:cw_blog/widgets/detailed_user.dart';
import 'package:cw_blog/widgets/personal_passage_mgr.dart';
import 'package:flutter/material.dart';

import '../frame/profile_mgr.dart';
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isNavigateToLogin=false;
  late AccountDataStruct accountData;
  int _selectedIndex=0;
  List<Widget> _pages=[
    DetailedUser(),
    PersonalPassageMgr(),
    About(),
  ];
  @override
  void initState() {
    super.initState();
    if(!profile.isOpen){
      initProfileBox();
      Future.delayed(Duration(milliseconds: 100));
    }
    accountData = AccountDataStruct.decodeToData(profile.get('accountData'));
  }
  void callSet(){
    accountData = AccountDataStruct.decodeToData(profile.get('accountData'));
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    if(accountData.nickName==''||accountData.accountsID==''){
      WidgetsFlutterBinding.ensureInitialized();
      if(mounted&&isNavigateToLogin==false){
        isNavigateToLogin=true;
        Future.delayed(Duration(milliseconds: 200),() async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Login(callBack: (){
            setState(() {

            });
          },)));
          if(!profile.isOpen){
            initProfileBox();
            Future.delayed(Duration(milliseconds: 100));
          }
          callSet();
        });
      }
    }
    void _onItemTapped(int index){
      _selectedIndex=index;
      setState(() {

      });
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width-80,
      child: Row(
        children: [
          Container(
            width: 250, // 固定宽度
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 菜单项
                ListTile(
                  leading: Icon(Icons.person_rounded),
                  title: Text('个人信息'),
                  onTap: () => _onItemTapped(0),
                  selected: _selectedIndex == 0,
                ),
                ListTile(
                  leading: Icon(Icons.article_rounded),
                  title: Text('文章管理'),
                  onTap: ()=>_onItemTapped(1),
                  selected: _selectedIndex==1,
                ),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('关于本站'),
                  onTap: () => _onItemTapped(2),
                  selected: _selectedIndex == 2,
                ),
              ],
            ),
          ),
          _pages[_selectedIndex]
        ],
      ),
    );
  }
}
