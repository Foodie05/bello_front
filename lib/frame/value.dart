import 'package:flutter/material.dart';

//website visit time
bool isVisitTimeGot=false;
int visitTime=0;
int debugTime=0;
//urls

final int webPort=8080;
final String serverUrl='https://cruty.cn:$webPort';
final String webSocketUrl='wss://cruty.cn:$webPort';
final String loginUrl='${serverUrl}/login';
final String registerUrl='${serverUrl}/register';
final String loginTwiceUrl='${serverUrl}/login_twice';
final String adminRegisterUrl='${serverUrl}/admin/register';
final String articleUrl='${serverUrl}/article';
final String adminAccountMgrUrl='${webSocketUrl}/admin/account_mgr';
final String visitRecUrl='${serverUrl}/visits';
final String debugUrl='${serverUrl}/debug';
const String additionalBottomInfo='陇ICP备2024014002号-1';
final String copyrightInfo='©2024 Tianyue, all rights reserved';
bool isRootPageInitialized=false;
const String webUrl='https://cruty.cn';

//texts
String icpBeian='陇ICP备2024014002号-1';
String webNotification='致每一位来访者：\n'
    '感谢您访问我的博客站\n在这里留下您的足迹\n'
    '虽仍简陋\n却是我一个月日日夜夜的付出\n'
    '我没有选择一条容易的路\n没有使用现成的博客系统\n而是一字一句从零敲起\n'
    '这是我对代码的热爱\n也是我对Flutter&Dart的执着\n'
    '你点击的每个按钮，每个窗口\n我都调试了几十上百遍\n'
    '每一次成功的访问背后\n都是我在服务器与客户端间一砖一瓦建起的桥梁\n'
    '我亲手搭建起这个网站\n我憧憬着她的繁荣\n'
    '欢迎您常来看看\n那时这里就不止有足迹、窗口和按钮\n'
    '还有时光岁月、热爱和生活。';

//app runtime
int runningVersion=5;
bool debug=true;

