import 'dart:convert';

import 'package:bello_front/request_model/visit_time.dart';
import 'package:bello_front/route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VisitTime extends StatefulWidget {
  const VisitTime({super.key});

  @override
  State<VisitTime> createState() => _VisitTimeState();
}

class _VisitTimeState extends State<VisitTime> {
  late VisitRequest visitRequest;
  VisitResponse? visitResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visitRequest=VisitRequest(isDebug: kDebugMode);
    getVisitTime();
  }
  Future<void> getVisitTime() async{
    Dio dio=Dio();
    try{
      var response=await dio.post(
          baseUrl+visitRoute,
          data: visitRequest.toJson()
      );
      if(response.statusCode==200){
        var responseData=jsonDecode(response.data);
        if(responseData!=null){
          setState(() {
            visitResponse=VisitResponse.fromJson(responseData);
          });
        }
      }else{
        setState(() {
          visitResponse=null;
        });
      }
    }catch(e){
     setState(() {
       visitResponse=null;
     });
    }
  }
  List<Widget> buildVisit(VisitResponse? visit){
    List<Widget> list=[];
    if(visit==null){
      list.add(Text('哎呀对不起什么也没加载出来>……<'));
    }else{
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('${visit.visitTime}',style: Theme.of(context).textTheme.displayLarge,),
            Text('次')
          ],
        )
      );
      list.add(Text('累计调试${visit.debugTime}次'));
      list.add(Text('感谢您的善意访问～！'));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('本网站累计访问:'),
        ]+buildVisit(visitResponse),
      ),
    );
  }
}
