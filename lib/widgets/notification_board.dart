import 'package:cw_blog/frame/value.dart';
import 'package:flutter/material.dart';

class NotificationBoard extends StatefulWidget {
  const NotificationBoard({super.key});

  @override
  State<NotificationBoard> createState() => _NotificationBoardState();
}

class _NotificationBoardState extends State<NotificationBoard> {
  String notification=webNotification;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20,right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 250,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('网站公告',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 24),),
              Text(notification,style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 18))
            ],
          )
        ],
      ),
    );
  }
}
