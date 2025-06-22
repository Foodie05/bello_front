import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class WelcomeBoard extends StatelessWidget {
  const WelcomeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(left: 20,right:20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primaryContainer
        ),
        alignment: Alignment.centerLeft,
        child: Text('欢迎来到\n云鲸岛的博客站！',style: TextStyle(fontSize: 24,color: Theme.of(context).colorScheme.onPrimaryContainer),textAlign: TextAlign.start,),
    );
  }
}
