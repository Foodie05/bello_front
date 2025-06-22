import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cw_blog/child_page/account/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart'as http;
import '../../frame/profile_mgr.dart';
import '../../frame/regulars.dart';
import '../../frame/value.dart';
import 'account_data_struct.dart';
import 'login_twice.dart';

class Login extends StatefulWidget {
  void Function() callBack;
  Login({
    required this.callBack
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _loginSelection='电话号码';
  String _id='';
  String _passwd='';
  String passwdMd5='';
  bool isLogging=false;
  String passwdSha256='';
  Future<void> _login() async {
    isLogging=true;//上锁
    setState(() {

    });
    if(_id==''||_passwd==''){
      FlutterToastr.show('必填项不可为空', context,backgroundColor: Theme.of(context).colorScheme.error,textStyle: TextStyle(color: Theme.of(context).colorScheme.onError,),duration: 2);
    }else{
      var bytes=utf8.encode(_passwd);
      passwdMd5=md5.convert(bytes).toString();
      passwdSha256= sha256.convert(bytes).toString();
      int selectedIndex=_loginSelection=='电话号码'?0:(_loginSelection=='电子邮箱'?1:2);
      String loginId=_id;
      final AccountDataStruct accountData=AccountDataStruct(
          msg: 'web login',
          loginMode: selectedIndex+1,
          phoneNumber: selectedIndex==0?loginId:null,
          email: selectedIndex==1?loginId:null,
          accountsID: selectedIndex==2?loginId:null,
          passwdMd5: passwdMd5,
          passwdSha256: passwdSha256
      );
      // 发送HTTPS POST请求
      final response = await http.post(
        Uri.parse(loginUrl),
        body: accountData.encodeToJson(),
      );

      if (response.statusCode == 200) {
        // 登陆成功
        AccountDataStruct answerForm=AccountDataStruct.decodeToData(response.body);//切分表单
        if(!profile.isOpen){
          initProfileBox();
        }
        answerForm.passwdMd5=accountData.passwdMd5;
        answerForm.passwdSha256=accountData.passwdSha256;
        profile.put('accountData', answerForm.encodeToJson());//本地存储信息
        if(answerForm.nickName==''){//说明需要初始化
          Future.delayed(Duration(milliseconds: 200),() async {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>LoginTwice()));
          });
        }
        if(answerForm.nickName!=''){
          if(mounted){
            FlutterToastr.show('登入成功！欢迎你，${answerForm.nickName}',context,backgroundColor:Theme.of(context).colorScheme.primaryContainer,duration: 2,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
          }
        }
        setState(() {

        });
        if(mounted){
          Future.delayed(Duration(seconds: 1),(){
            Navigator.pop(context);
          });
        }
      }else{//不成功的逻辑
        isLogging=false;
        setState(() {
          FlutterToastr.show('登入失败！请检查您的信息',context,backgroundColor:Theme.of(context).colorScheme.errorContainer,duration: 2,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
        });
      }
    }
    isLogging=false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width-80,
        child: Container(
          height: 450,
          width: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Theme.of(context).colorScheme.primaryContainer,width: 3)
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RegularHeightSpacing(),
              Text('登入云鲸岛',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 32),),
              RegularHeightSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('登入方式      ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16),),
                  DropdownButton<String?>(
                      value: _loginSelection,
                      items: [
                        DropdownMenuItem(child: Text('电话号码'),value: '电话号码',),
                        DropdownMenuItem(child: Text('电子邮箱'),value: '电子邮箱',),
                        DropdownMenuItem(child: Text('账户ID'),value: '账户ID',),
                      ],
                      onChanged: (String? selection){
                        if(selection!=null){
                          setState(() {
                            _loginSelection=selection;
                          });
                        }
                      }
                  )
                ],
              ),
              RegularHeightSpacing(),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    border: Border.all(color: Theme.of(context).colorScheme.primaryContainer,width: 3)
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _loginSelection,
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                  ),
                  onChanged: (String id){
                    _id=id;
                    setState(() {

                    });
                  },
                ),
              ),
              RegularHeightSpacing(),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    border: Border.all(color: Theme.of(context).colorScheme.primaryContainer,width: 3)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '密码',
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                  ),
                  onChanged: (String passwd){
                    _passwd=passwd;
                    setState(() {

                    });
                  },
                ),
              ),
              RegularHeightSpacing(),
              ElevatedButton(

                  onPressed: () {
                    if(isLogging==false){
                      _login();
                    }else{

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer, // 背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // 圆角
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 内边距
                  ),
                  child: isLogging==false?Text('登入',style: TextStyle(fontSize: 18),):CircularProgressIndicator()
              ),
              RegularHeightSpacing(),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Register(callBack: (){
                      setState(() {

                      });
                      if(mounted){
                        Future.delayed(Duration(milliseconds: 200),(){
                          Navigator.pop(context);
                        });
                      }
                    },)));
                  },
                  child: Text('立即注册',style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
