import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class FriendlyLink extends StatelessWidget {
  const FriendlyLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20,right:20),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.primaryContainer
      ),
      alignment: Alignment.centerLeft,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('友情链接：',style: TextStyle(fontSize: 24,color: Theme.of(context).colorScheme.onPrimaryContainer),textAlign: TextAlign.start,),
              GestureDetector(
                onTap: (){
                  if(kIsWeb){
                    html.window.open('https://www.dawnpe.com/','_blank');
                  }
                },
                child: Text('晨云网络',style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.onPrimaryContainer))
              )
            ],
          )
        ],
      )
    );
  }
}
