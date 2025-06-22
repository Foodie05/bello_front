import 'package:cw_blog/child_page/article/article_data_struct.dart';
import 'package:cw_blog/frame/regulars.dart';
import 'package:cw_blog/pages/goto_article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../frame/value.dart';
class Articles extends StatefulWidget {
  ArticleDetail? articleFilter;
  Articles({
    this.articleFilter,//用于控制搜索的过滤器
    super.key
  });

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  int isGettingArticle=1;//1-getting 0-got 2-lost
  bool buildingLock=false;
  List<Widget> articles=[];
  ArticleDataStruct articleDataStruct=ArticleDataStruct('list');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.articleFilter!=null){
      articleDataStruct.articles=[widget.articleFilter!];//将过滤器配置到访问请求
    }
    buildArticleList(context);
  }

  Future<void> buildArticleList(BuildContext context) async {
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      articleDataStruct=ArticleDataStruct.decodeToData(response.body);
      isGettingArticle=0;
      setState(() {

      });
    }else{//not found
      isGettingArticle=2;
      setState(() {

      });
    }
    buildingLock=false;//解锁
  }
  List<Widget> buildList(){
    articles.clear();
    for(int i=articleDataStruct.articleDetail.length-1;i>=0;i--){
      String previewTxt=articleDataStruct.articleDetail[i].txt.characters.length<20?articleDataStruct.articleDetail[i].txt:'${articleDataStruct.articleDetail[i].txt.substring(0,20)}...';
      previewTxt=previewTxt.replaceAll('\n', ' ');
      String editTime=' ${articleDataStruct.articleDetail[i].time.year}-${articleDataStruct.articleDetail[i].time.month.toString().padLeft(2,'0')}-${articleDataStruct.articleDetail[i].time.day.toString().padLeft(2,'0')} ${articleDataStruct.articleDetail[i].time.hour.toString().padLeft(2,'0')}:${articleDataStruct.articleDetail[i].time.minute.toString().padLeft(2,'0')}:${articleDataStruct.articleDetail[i].time.second.toString().padLeft(2,'0')}    ';
      List<WidgetSpan> labelWidgets=[];
      List<String> labels=[articleDataStruct.articleDetail[i].label1,articleDataStruct.articleDetail[i].label2,articleDataStruct.articleDetail[i].label3,articleDataStruct.articleDetail[i].label4,articleDataStruct.articleDetail[i].label5];
      for(int i=0;i<labels.length;i++){
        if(labels[i]!=''){
          labelWidgets.addAll([WidgetSpan(
              child: Chip(
                label: Text(
                  labels[i],
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                labelPadding: EdgeInsets.only(left: 2,right: 2,top: 0,bottom: 0),
                labelStyle: TextStyle(fontSize: 16),
              )
          ),
            WidgetSpan(child: SizedBox(width: 5,)),]);
        }
      }
      articles.add(GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>GotoArticle(articleID: articleDataStruct.articleDetail[i].articleID)));
        },
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          height: 180,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 3
            ),
          ),
          child: RichText(
            text: TextSpan(
                style: TextStyle(height: 1.5),
                children: [
                  TextSpan(text: '${articleDataStruct.articleDetail[i].title}\n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 28)),
                  TextSpan(text: '$previewTxt\n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                  TextSpan(
                      children:[
                        TextSpan(text: ''),
                        WidgetSpan(child: Icon(Icons.person_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,),alignment: PlaceholderAlignment.middle,baseline: TextBaseline.alphabetic),
                        TextSpan(text: ' ${articleDataStruct.articleDetail[i].author}    ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                        WidgetSpan(child: Icon(Icons.edit_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,),alignment: PlaceholderAlignment.middle,baseline: TextBaseline.alphabetic),
                        TextSpan(text: editTime,style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                        WidgetSpan(child: Icon(Icons.remove_red_eye_rounded,color: Theme.of(context).colorScheme.onPrimaryContainer,size: 16,),alignment: PlaceholderAlignment.middle,baseline: TextBaseline.alphabetic),
                        TextSpan(text: ' ${articleDataStruct.articleDetail[i].viewCount} \n',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16)),
                      ]+labelWidgets
                  )
                ]
            ),
          ),
        ),
      ));
      articles.add(RegularHeightSpacing());
    }
    return articles;
  }
  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isGettingArticle==1?[CircularProgressIndicator()]:(isGettingArticle==0?buildList():[Text('404 Not Found\n请向云鲸转告此事',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 22))]),
    );
  }
}
