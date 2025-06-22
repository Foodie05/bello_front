import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../frame/value.dart';
import 'dart:js' as js;
class VisitTimes extends StatefulWidget {
  const VisitTimes({super.key});

  @override
  State<VisitTimes> createState() => _VisitTimesState();
}

class _VisitTimesState extends State<VisitTimes> {
  @override
  void initState() {
    super.initState();
    visitRecord();
  }
  void refreshBrowser(){
    js.context['location']['reload']();
  }
  visitRecord() async {
    if(isVisitTimeGot==false){
      final debugResponse=await http.get(Uri.parse(debugUrl));
      if(debugResponse.statusCode==200){
        if(debug==true){
          await http.post(Uri.parse(debugUrl));
        }
        if(mounted){
          Future.delayed(Duration(milliseconds: 200),(){
            setState(() {
              debugTime = jsonDecode(debugResponse.body)['times']+1;
            });
          });
        }
      }
      final response = await http.get(Uri.parse(visitRecUrl));
      if(response.statusCode==200){
        if(debug==false){
          await http.post(Uri.parse(visitRecUrl));
        }
        if(mounted){
          Future.delayed(Duration(milliseconds: 200),(){
            setState(() {
              visitTime = jsonDecode(response.body)['times']+1;
              int version=jsonDecode(response.body)['version'];
              if(runningVersion<version){
                if(kIsWeb&&debug==false){
                  //html.window.open(webUrl, '_self');
                  refreshBrowser();
                }
              }
            });
          });
        }
      }
      isVisitTimeGot=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primaryContainer
        ),
        margin: EdgeInsets.only(left:20,right: 20),
        padding: EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
              children: [
                TextSpan(text: '欢迎您！\n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 32)),
                TextSpan(text: '本网站累积访问\n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24)),
                TextSpan(text: '$visitTime',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 48)),
                TextSpan(text: '次\n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24)),
                TextSpan(text: '经历调试$debugTime次',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24)),
              ]
          ),
        )
    );
  }
}

