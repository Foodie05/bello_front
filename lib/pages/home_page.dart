import 'package:cw_blog/frame/regulars.dart';
import 'package:cw_blog/widgets/articles.dart';
import 'package:cw_blog/widgets/friendly_link.dart';
import 'package:cw_blog/widgets/icp_beian.dart';
import 'package:cw_blog/widgets/notification_board.dart';
import 'package:cw_blog/widgets/portal.dart';
import 'package:cw_blog/widgets/short_link.dart';
import 'package:cw_blog/widgets/visit_times.dart';
import 'package:cw_blog/widgets/welcome_board.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText='';
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const RegularHeightSpacing(),
          Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.primaryContainer
            ),
            height: 45,
            width: 450,
            child: TextField(
              onChanged:(String txt){
                searchText=txt;
                setState(() {

                });
              },
              decoration: InputDecoration(
                hintText: '搜索功能暂不可用～',
                icon: Icon(Icons.search,color: Theme.of(context).colorScheme.onPrimaryContainer,),
                border: InputBorder.none,
              ),
            ),
          ),
          RegularHeightSpacing(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:Container(
                  margin: EdgeInsets.only(left: 20),
                  height: MediaQuery.of(context).size.height-85,//减去上面的85个像素的搜索框和边距
                  child: ListView(
                    children: [
                      Articles()
                    ],
                  ),
                )
              ),//for regular article listview
              Container(
                width: 300,
                height: MediaQuery.of(context).size.height-85,
                child: ListView(
                  children: const [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WelcomeBoard(),
                        RegularHeightSpacing(),
                        Portal(),
                        RegularHeightSpacing(),
                        ShortLink(),
                        RegularHeightSpacing(),
                        VisitTimes(),
                        RegularHeightSpacing(),
                        NotificationBoard(),
                        RegularHeightSpacing(),
                        FriendlyLink(),
                        RegularHeightSpacing(),
                        IcpBeian(),
                        RegularHeightSpacing(),
                      ],
                    ),
                  ],
                ),
              )//for some extra widgets
            ],
          ),
        ],
      ),
    );
  }
}
