import 'dart:convert';

import 'package:cw_blog/child_page/account/account_data_struct.dart';
import 'package:cw_blog/child_page/article/article_data_struct.dart';
import 'package:cw_blog/frame/profile_mgr.dart';
import 'package:cw_blog/frame/regulars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../frame/theme.dart';
import '../frame/value.dart';
class ArticleEdit extends StatefulWidget {
  const ArticleEdit({super.key});

  @override
  State<ArticleEdit> createState() => _ArticleEditState();
}

class _ArticleEditState extends State<ArticleEdit> {
  String txt='';
  String title='';
  bool isSending=false;
  String label1='';
  String label2='';
  String label3='';
  String label4='';
  String label5='';
  List<String> labels=[];
  bool isLabelGot=false;
  late AccountDataStruct accountData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!profile.isOpen){
      initProfileBox();
      Future.delayed(Duration(milliseconds: 100));
    }
    getLabels();
    accountData = AccountDataStruct.decodeToData(profile.get('accountData'));
  }
  void addNewLabels(){//添加新的标签
    bool isSending=false;
    String newLabels='';
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('可以添加新的标签'),
        content: TextField(
          decoration: InputDecoration(
            hintText:'请输入标签',
            border: InputBorder.none,
          ),
          onChanged: (String text){
            newLabels=text;
            setState(() {

            });
          },
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if(isSending==true){
                  return;
                }
                isSending=true;
                setState(() {

                });
                await sendLabels(newLabels);
                getLabels();
                isSending=false;
                if(mounted){
                  Future.delayed(Duration(milliseconds: 200),(){
                    Navigator.pop(context);
                  });
                }
              },
              child: isSending==false?Text('好'):CircularProgressIndicator()
          )
        ],
      );
    });
  }
  Future<void> sendLabels(String label)async{
    ArticleDataStruct articleDataStruct=ArticleDataStruct(
      'add_label',
      passwdMd5: accountData.passwdMd5,
      passwdSha256: accountData.passwdSha256,
      accountsID: accountData.accountsID,
      articles: [ArticleDetail(title: '', author: '', time: DateTime(1970), viewCount: 0, visiblePermission: 0, txt: '', coverPic: '', articleID: 0, label1: label, label2: '', label3: '', label4: '', label5: '', accountsID: '')]
    );
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      FlutterToastr.show('添加成功:${response.body}', duration: 2,context,backgroundColor: Theme.of(context).colorScheme.primaryContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
    }else{//提交失败
      FlutterToastr.show('无法添加新的标签:${response.body}', duration: 2,context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
    }
  }
  Future<void> getLabels() async {
    ArticleDataStruct articleDataStruct=ArticleDataStruct(
        'get_label',
    );
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      //此处返回的是一个json的List<String>
      try{
        var decode=jsonDecode(response.body);
        labels=List<String>.from(decode);
      }catch(e){
        labels=[];
      }
      isLabelGot=true;
     }else{//提交失败
      FlutterToastr.show('无法获取文章标签:${response.body}', duration: 2,context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
    }
  }
  List<DropdownMenuItem<String>> buildLabelDropdownMenu(){
    List<DropdownMenuItem<String>> lists=[];
    if(isLabelGot==false){
      if(mounted){
        Future.delayed(Duration(milliseconds: 200),(){
          FlutterToastr.show('未能获取文章标签', duration: 2,context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
        });
      }
      return lists;
    }else{
      for(int i=0;i<labels.length;i++){
        lists.add(DropdownMenuItem(child: Text(labels[i]),value: labels[i],),);
      }
      return lists;
    }
  }
  Widget buildMarkDown()=>MarkdownWidget(data: txt);
  void sendArticle(){
    if(isSending==true){
      return;
    }else{
      if(txt==''){
        FlutterToastr.show('文本内容不能为空', context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),duration: 2);
        return;
      }
      showDialog(context: context, builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context,StateSetter setState){
            return AlertDialog(
              title: Text('',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),),
              content: Container(
                height: 250,
                width: 300,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          width: 350,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                              border: Border.all(color: Theme.of(context).colorScheme.primaryContainer,width: 3),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:'请输入标题',
                              border: InputBorder.none,
                            ),
                            onChanged: (String text){
                              title=text;
                              setState(() {

                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('标签1 '),
                            DropdownButton<String?>(
                                value: label1,
                                items: [DropdownMenuItem(child: Text('无'),value: '',),]+buildLabelDropdownMenu(),
                                onChanged: (String? selection){
                                  if(selection!=null){
                                    setState(() {
                                      label1=selection;
                                    });
                                  }
                                }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('标签2 '),
                            DropdownButton<String?>(
                                value: label2,
                                items: [DropdownMenuItem(child: Text('无'),value: '',),]+buildLabelDropdownMenu(),
                                onChanged: (String? selection){
                                  if(selection!=null){
                                    setState(() {
                                      label2=selection;
                                    });
                                  }
                                }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('标签3 '),
                            DropdownButton<String?>(
                                value: label3,
                                items: [DropdownMenuItem(child: Text('无'),value: '',),]+buildLabelDropdownMenu(),
                                onChanged: (String? selection){
                                  if(selection!=null){
                                    setState(() {
                                      label3=selection;
                                    });
                                  }
                                }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('标签4 '),
                            DropdownButton<String?>(
                                value: label4,
                                items: [DropdownMenuItem(child: Text('无'),value: '',),]+buildLabelDropdownMenu(),
                                onChanged: (String? selection){
                                  if(selection!=null){
                                    setState(() {
                                      label4=selection;
                                    });
                                  }
                                }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('标签5 '),
                            DropdownButton<String?>(
                                value: label5,
                                items: [DropdownMenuItem(child: Text('无'),value: '',),]+buildLabelDropdownMenu(),
                                onChanged: (String? selection){
                                  if(selection!=null){
                                    setState(() {
                                      label5=selection;
                                    });
                                  }
                                }
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await submitArticleToWeb();
                      Navigator.pop(context);
                      isSending=false;
                      setState(() {

                      });
                    },
                    child: Text('好',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),)
                ),
              ],
            );
          }
        );
      });
    }
  }
  Future submitArticleToWeb() async{
    if(title==''){
      FlutterToastr.show('标题不能为空', context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),duration: 2);
      return;
    }
    isSending=true;//上锁
    setState(() {

    });
    //检查设置重复的标签并替换成空字符串
    List<String> labels = [label1, label2, label3, label4, label5];
    Set<String> seen = {};
    List<String> result = [];
    // 检查重复并替换
    for (var label in labels) {
      if (label != '' && seen.contains(label)) {
        result.add(''); // 如果重复，设为空字符串
      } else {
        result.add(label); // 如果不重复，保留原值
        seen.add(label);
      }
    }
    // 更新变量
    label1 = result[0];
    label2 = result[1];
    label3 = result[2];
    label4 = result[3];
    label5 = result[4];
    ArticleDetail currentArticle=ArticleDetail(
        title: title,
        author: accountData.nickName,
        time: DateTime.now(),
        viewCount: 0,
        visiblePermission: 5,
        txt: txt,
        coverPic: '',
        articleID: 1,
        label1: label1,
        label2: label2,
        label3: label3,
        label4: label4,
        label5: label5,
        accountsID: accountData.accountsID
    );
    ArticleDataStruct articleDataStruct=ArticleDataStruct(
      'submit',
      accountsID: accountData.accountsID,
      passwdMd5: accountData.passwdMd5,
      passwdSha256: accountData.passwdSha256,
      articles: [
        currentArticle
      ]
    );
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      FlutterToastr.show('提交成功', context,duration: 2,backgroundColor: Theme.of(context).colorScheme.primaryContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
    }else{//提交失败
      FlutterToastr.show(ArticleDataStruct.decodeToData(response.body).msg, duration: 2,context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
    }
    isSending=false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                addNewLabels();
              },
              icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: (){
                context.read<ThemeSwitch>().switchTheme();
              },
              icon: Icon(ThemeSwitch().isDark==true?Icons.dark_mode_rounded:Icons.light_mode_rounded)
          ),
          IconButton(
              onPressed: (){
                sendArticle();
              },
              icon: isSending==false?Icon(Icons.send):CircularProgressIndicator()
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-246,
                  margin: EdgeInsets.only(left: 20,right: 10),
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width/2-30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 3
                    )
                  ),
                  child: TextField(
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    maxLines: null,
                    onChanged: (String text){
                      txt=text;
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请在此输入文字，右边会实时展示Markdown格式的文本'
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height-246,
                  margin: EdgeInsets.only(right:20,left: 10),
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width/2-30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 3
                      )
                  ),
                  child: buildMarkDown()
                )
              ],
            ),
            RegularHeightSpacing(),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 3
                  )
              ),
              height: 150,
              child: ListView(
                children: [
                  Text('部分Markdown语法：\n'
                      '#+空格后输入内容，整行成为标题，井号最多有6个，标题层级递减\n'
                      '** **中间的内容会被加粗\n'
                      '* *中间的内容会变为斜体\n'
                      '>加空格，后面的内容变为引用\n'
                      '- [] 显示代办，- [x] 显示已经完成\n'
                      '~~ ~~中间的内容加上删除线\n'
                      '[]() 方括号里填写名称，圆括号填写链接，可以生成跳转链接，不过要记得在链接前加http://或者https://\n'
                      '![]() 方括号填写简介，圆括号填写图片链接，会将图片展示在页面上\n'
                      '您可以自行了解更多Markdown语法并进行尝试～！',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
