import 'package:cw_blog/child_page/account/account_data_struct.dart';
import 'package:cw_blog/child_page/article/article_data_struct.dart';
import 'package:flutter/material.dart';

import '../frame/profile_mgr.dart';
import 'articles.dart';

class PersonalPassageMgr extends StatefulWidget {
  const PersonalPassageMgr({super.key});

  @override
  State<PersonalPassageMgr> createState() => _PersonalPassageMgrState();
}

class _PersonalPassageMgrState extends State<PersonalPassageMgr> {
  AccountDataStruct accountData=AccountDataStruct(msg: 'need init');
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
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Articles(articleFilter: ArticleDetail(title: '', author: '', time: DateTime(1970), viewCount: 0, visiblePermission: 0, txt: '', coverPic: '', articleID: 0, label1: '', label2: '' , label3: '', label4: '', label5: '', accountsID: accountData.accountsID),)
          ],
        ),
      ),
    );
  }
}
