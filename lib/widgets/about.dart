import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

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
          Text('开发者：云鲸',style: TextStyle(fontSize: 16)),
          Text('前端：Flutter Web',style: TextStyle(fontSize: 16)),
          Text('服务端：Dart',style: TextStyle(fontSize: 16)),
          Text('联系方式：QQ 2900830468',style: TextStyle(fontSize: 16)),
          Text('网站仍在第一阶段建设中...感谢您的访问！',style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
