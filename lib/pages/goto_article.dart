import 'package:cw_blog/child_page/account/account_data_struct.dart';
import 'package:cw_blog/child_page/article/article_data_struct.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart' as http;
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import '../frame/profile_mgr.dart';
import '../frame/theme.dart';
import '../frame/value.dart';
import 'dart:html' as html;

class GotoArticle extends StatefulWidget {
  int articleID;
  GotoArticle({
    required this.articleID
  });
  @override
  State<GotoArticle> createState() => _GotoArticleState();
}

class _GotoArticleState extends State<GotoArticle> {
  AccountDataStruct accountData=AccountDataStruct(msg: 'should be init');
  int isLoadingArticle=1;//loading-1,loaded-0,not found-2
  String txt='';
  String title='';
  String author='';
  DateTime editTime=DateTime(1970);
  String timeToDisplay='';
  int viewCount=0;
  String accountsID='';
  Widget buildMarkDown()=>MarkdownWidget(data: txt);
  void deleteArticle(){//删除文章
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('确定要删除吗？此操作不可撤销！'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('取消')
          ),
          TextButton(
              onPressed: (){
                secondaryEnsure();
              }, 
              child: Text('删除',style: TextStyle(color: Theme.of(context).colorScheme.error),)
          )
        ],
      );
    });
  }
  void secondaryEnsure(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('这是最后一次确认！此操作不可撤销！'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('取消')
          ),
          TextButton(
              onPressed: () async {
                await sendDeleteRequest();
                if(mounted){
                  Future.delayed(Duration(milliseconds: 200),(){
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('删除',style: TextStyle(color: Theme.of(context).colorScheme.error),)
          )
        ],
      );
    });
  }
  Future<void> copyToClipboard(String content) async {
    if(kIsWeb){
      html.window.navigator.clipboard?.writeText(content).then((_) {

      }).catchError((e) {

      });
    }else{
      await Clipboard.setData(ClipboardData(text: content));
    }

  }
  Future<void> sendDeleteRequest() async {//真正发出删除请求
    ArticleDataStruct articleDataStruct=ArticleDataStruct('del_article',passwdMd5:accountData.passwdMd5,passwdSha256:accountData.passwdSha256,accountsID:accountData.accountsID,articles: [ArticleDetail(title: '', author: '', time: DateTime(1970), viewCount: 0, visiblePermission: 0, txt: '', coverPic: '', articleID: widget.articleID, label1: '', label2: '', label3: '', label4: '', label5: '', accountsID: '')]);
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      articleDataStruct=ArticleDataStruct.decodeToData(response.body);
      await copyToClipboard(txt);
      FlutterToastr.show('成功删除！为防止误操作，已将文章内容复制到剪贴板', context,duration: 2,backgroundColor: Theme.of(context).colorScheme.primaryContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
      setState(() {

      });
    }else{//not found
      FlutterToastr.show('删除失败：${response.body}', context,duration: 2,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
      setState(() {

      });
    }
    if(mounted){
      Future.delayed(Duration(milliseconds: 200),(){
        Navigator.pop(context);
      });
    }
  }
  Future<void> loadArticle() async {
    ArticleDataStruct articleDataStruct=ArticleDataStruct('checkID');
    articleDataStruct.articles=[ArticleDetail(accountsID:'',title: '', author: '', time: DateTime(1970), viewCount: 0, visiblePermission: 0, txt: '', coverPic: '', articleID: widget.articleID, label1: '', label2: '', label3: '', label4: '', label5: '')];
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//获取成功
      articleDataStruct=ArticleDataStruct.decodeToData(response.body);
      if(articleDataStruct.articleDetail.isNotEmpty){
        txt=articleDataStruct.articleDetail[0].txt;
        title=articleDataStruct.articleDetail[0].title;
        author=articleDataStruct.articleDetail[0].author;
        editTime=articleDataStruct.articleDetail[0].time;
        timeToDisplay='${editTime.year}-${editTime.month.toString().padLeft(2,'0')}-${editTime.day.toString().padLeft(2,'0')} ${editTime.hour.toString().padLeft(2,'0')}:${editTime.minute.toString().padLeft(2,'0')}:${editTime.second.toString().padLeft(2,'0')}';
        viewCount=articleDataStruct.articleDetail[0].viewCount;
        accountsID=articleDataStruct.articleDetail[0].accountsID;
        isLoadingArticle=0;
        setState(() {

        });
      }else{
        isLoadingArticle=2;
        setState(() {

        });
      }
    }else{//获取失败
      isLoadingArticle=2;
      setState(() {

      });
    }
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
    loadArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if(accountData.accountsID==accountsID||accountData.accountPermission<=1)
            IconButton(
                onPressed: (){
                  deleteArticle();
                },
                icon: Icon(Icons.delete_rounded,color: Theme.of(context).colorScheme.error,)
            ),
          IconButton(
              onPressed: ()async{
                await copyToClipboard('【云鲸岛的博客】好友分享给你一篇文章，前往https://cruty.cn并通过传送门前往文章ID ${widget.articleID} 查看。');
                FlutterToastr.show('已将分享内容复制到剪贴板！', context,duration: 2,backgroundColor: Theme.of(context).colorScheme.primaryContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
              },
              icon: Icon(Icons.ios_share)
          ),
          IconButton(
              onPressed: (){
                context.read<ThemeSwitch>().switchTheme();
              },
              icon: Icon(ThemeSwitch().isDark==true?Icons.dark_mode_rounded:Icons.light_mode_rounded)
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: isLoadingArticle==1?CircularProgressIndicator():
        (isLoadingArticle==0?
        Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 32),),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        children:[
                          WidgetSpan(child: Icon(Icons.person_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,)),
                          TextSpan(text: '$author    ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                          WidgetSpan(child: Icon(Icons.edit_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,)),
                          TextSpan(text: '$timeToDisplay   ' ,style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                          WidgetSpan(child: Icon(Icons.remove_red_eye_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,),),
                          TextSpan(text: ' $viewCount',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                        ]
                    )
                  ]
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: buildMarkDown(),
              height: MediaQuery.of(context).size.height-128,
            )
        ],):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.error_rounded,color: Theme.of(context).colorScheme.primaryContainer,size: 72,),
                Text('404 Not Found\n文章不存在或服务器错误',style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer,fontSize: 32),)
            ],)
        ),
      )
    );
  }
}
