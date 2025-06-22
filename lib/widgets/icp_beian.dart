import 'package:cw_blog/frame/value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
class IcpBeian extends StatelessWidget {
  const IcpBeian({super.key});
  _launchURL() async {
    const url = 'https://beian.miit.gov.cn/';
    if(kIsWeb){
      html.window.open(url,'_blank');
    }else{
      if (await canLaunchUrl(Uri(path: 'https://beian.miit.gov.cn/'))) {
        await launchUrl(Uri(path: 'https://beian.miit.gov.cn/'));
      } else {
        throw 'Could not launch $url';
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        _launchURL();
      },
      child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.primaryContainer
          ),
          margin: EdgeInsets.only(left:20,right: 20),
          padding: EdgeInsets.all(20),
          child:Text(icpBeian,style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16),)
      ),
    );
  }
}
