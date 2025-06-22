import 'package:cw_blog/pages/goto_article.dart';
import 'package:flutter/material.dart';

class Portal extends StatefulWidget {
  const Portal({super.key});

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  void goPortal(){
    int articleID=0;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('传送门'),
        content: TextField(
          decoration: InputDecoration(
            hintText:'请输入文章ID',
            border: InputBorder.none,
          ),
          onChanged: (String text){
            articleID=int.tryParse(text)??0;
            setState(() {

            });
          },
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>GotoArticle(articleID: articleID)));
                if(mounted){
                  Future.delayed(Duration(milliseconds: 200),(){
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('好')
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        goPortal();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primaryContainer
        ),
        margin: EdgeInsets.only(left: 20,right: 20),
        padding: EdgeInsets.all(25),
        child: Text('传送门由此入～',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 28),),
      ),
    );
  }
}