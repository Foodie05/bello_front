import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../frame/regulars.dart';
import '../../frame/value.dart';
import 'account_data_struct.dart';

class Register extends StatefulWidget {
  void Function() callBack;
  Register({
    required this.callBack
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String phoneNumber='';
  late String passwdMd5;//密码的Md5校验
  late String passwdSha256;//密码的Sha256校验
  String _passwd='';
  String redoPasswd='';
  String nickName='';//昵称
  String? gender;//性别，可不填
  String? signature;//个性签名
  String? email;
  String? errorPrompt;//这是填入了错误信息后的系统提示
  bool isRegistering=false;//如果正在注册，则不允许重复按按钮
  String results='';
  String invitationCode='';//邀请码，云鲸岛将长期保持邀请制注册
  Future<void> _register() async {
    if(isRegistering==true){
      return;
    }else{
      isRegistering=true;//上锁
      setState(() {

      });
    }
    bool checkResult=true;
    if(phoneNumber==''||_passwd==''||redoPasswd==''||nickName==''||invitationCode==''){
      FlutterToastr.show('必填项不可为空', context,backgroundColor: Theme.of(context).colorScheme.error,textStyle: TextStyle(color: Theme.of(context).colorScheme.onError,),duration: 2);
      checkResult=false;
    }
    if(_passwd!=redoPasswd){
      FlutterToastr.show('密码前后不一致', context,backgroundColor: Theme.of(context).colorScheme.error,textStyle: TextStyle(color: Theme.of(context).colorScheme.onError,),duration: 2);
      checkResult=false;
    }
    if(int.tryParse(phoneNumber)==null||phoneNumber.length<4){
      FlutterToastr.show('手机号码必须是纯数字且必须长于4位', context,backgroundColor: Theme.of(context).colorScheme.error,textStyle: TextStyle(color: Theme.of(context).colorScheme.onError,),duration: 2);
      checkResult=false;
    }
    if(checkResult==false){//如果是空的，那么拒绝执行
      setState(() {
        isRegistering=false;
      });
      return;
    }
    var bytes=utf8.encode(_passwd);
    passwdMd5=md5.convert(bytes).toString();
    passwdSha256= sha256.convert(bytes).toString();
    AccountDataStruct accountData=AccountDataStruct(
        msg: 'web register',
        phoneNumber: phoneNumber,
        nickName: nickName,
        email: email,
        gender: gender,
        signature: signature,
        passwdMd5: passwdMd5,
        passwdSha256: passwdSha256,
        invitationCode: invitationCode
    );


    // 发送HTTPS POST请求
    final response = await http.post(
      Uri.parse(registerUrl),
      body: accountData.encodeToJson(),
    );

    if (response.statusCode == 200) {
      // 注册成功
      AccountDataStruct answerForm=AccountDataStruct.decodeToData(response.body);//切分表单
      Box profile=Hive.box('profile');
      if(profile.containsKey('accountData')){
        profile.delete('accountData');
      }
      accountData.accountPermission=answerForm.accountPermission;
      accountData.accountsID=answerForm.accountsID;
      profile.put('accountData', accountData.encodeToJson());
      results='注册成功！';
      if(mounted){
        FlutterToastr.show('注册成功！欢迎你，$nickName!', context,duration: 2,backgroundColor: Theme.of(context).colorScheme.primaryContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer));
      }
      setState(() {
        isRegistering=false;
      });
      Future.delayed(Duration(seconds: 2),(){
        Navigator.pop(context);
      });
    } else {
      // 注册失败
      if (mounted) {
        FlutterToastr.show(
            '非常抱歉注册失败：${AccountDataStruct
                .decodeToData(response.body)
                .msg}，也许您的邮箱或者电话号码已经注册过了',
            context, duration: 2,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .errorContainer,
            textStyle: TextStyle(color: Theme
                .of(context)
                .colorScheme
                .onErrorContainer)
        );
      }
      setState(() {
        isRegistering = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          height:700,
          width: 400,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Theme.of(context).colorScheme.primaryContainer,width: 3)
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RegularHeightSpacing(),
                  Text('注册云鲸岛',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 32),),
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
                          hintText: '电话号码',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String phoneNum){
                        phoneNumber=phoneNum;
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
                          hintText: '重复密码',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String passwd){
                        redoPasswd=passwd;
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '昵称',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String name){
                        nickName=name;
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '邀请码',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String code){
                        invitationCode=code;
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '电子邮箱（选填）',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String mail){
                        email=mail;
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '个性签名（选填）',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)
                      ),
                      onChanged: (String sig){
                        signature=sig;
                        setState(() {

                        });
                      },
                    ),
                  ),
                  RegularHeightSpacing(),
                  ElevatedButton(
                    onPressed: () {
                      _register();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer, // 背景色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // 圆角
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 内边距
                    ),
                    child: isRegistering==false?Text('注册',style: TextStyle(fontSize: 18),):CircularProgressIndicator(),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
