import 'package:cw_blog/child_page/account/account_data_struct.dart';
import 'package:cw_blog/frame/regulars.dart';
import 'package:flutter/material.dart';
import '../frame/profile_mgr.dart';
class DetailedUser extends StatefulWidget {
  const DetailedUser({super.key});

  @override
  State<DetailedUser> createState() => _DetailedUserState();
}

class _DetailedUserState extends State<DetailedUser> {
  AccountDataStruct accountData=AccountDataStruct(msg: '');
  List<String> identity=[
    '终极管理员',
    '管理员',
    '荣誉作者',
    '高级访客',
    '访客',
    '黑名单'
  ];
  void _logOut(){
    if(!profile.isOpen){
      initProfileBox();
      Future.delayed(Duration(milliseconds: 100));
    }
    profile.delete('accountData');
    accountData=AccountDataStruct.decodeToData('');
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!profile.isOpen){
      initProfileBox();
      Future.delayed(Duration(milliseconds: 100));
    }
    accountData = AccountDataStruct.decodeToData(profile.get('accountData'));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 400,
      height: 300,
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('昵称：${accountData.nickName}',style: TextStyle(fontSize: 16),),
          Text('身份: ${accountData.nickName==''?'':identity[accountData.accountPermission]}',style: TextStyle(fontSize: 16)),
          Text('个性签名：${accountData.signature}',style: TextStyle(fontSize: 16)),
          Text('账户ID：${accountData.accountsID}',style: TextStyle(fontSize: 16)),
          Text('电话号码：${accountData.phoneNumber}',style: TextStyle(fontSize: 16)),
          Text('邮箱：${accountData.email}',style: TextStyle(fontSize: 16)),
          RegularHeightSpacing(),
          ElevatedButton(
              onPressed: () {
                _logOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer, // 背景色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25), // 圆角
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 内边距
              ),
              child: Text('注销')
          ),
        ],
      ),
    );
  }
}
