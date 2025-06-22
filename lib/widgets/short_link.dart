import 'package:flutter/material.dart';
class ShortLink extends StatefulWidget {
  const ShortLink({super.key});

  @override
  State<ShortLink> createState() => _ShortLinkState();
}

class _ShortLinkState extends State<ShortLink> {
  String originUrl='';
  String expectedShortName='';
  int lastDays=1;
  void createShortLink(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('创建您的短链接'),
        content: Container(
          height: MediaQuery.of(context).size.height/6,
          width: MediaQuery.of(context).size.width/3,
          child: ListView(
            children: [
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText:'请输入需要转为短链的URL',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text){
                      originUrl=text;
                      setState(() {

                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText:'输入您想要的短链名称（通常几个字符即可）',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text){
                      expectedShortName=text;
                      setState(() {

                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText:'输入有效期（天数）',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text){
                      lastDays=int.tryParse(text)??7;
                      setState(() {

                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
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
        createShortLink();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primaryContainer
        ),
        margin: EdgeInsets.only(left: 20,right: 20),
        padding: EdgeInsets.all(25),
        child: Text('短链生成由此入～',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 28),),
      ),
    );
  }
}
void redirectPage(String shortCode){

}
