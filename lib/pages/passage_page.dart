import 'dart:convert';

import 'package:cw_blog/frame/regulars.dart';
import 'package:cw_blog/pages/article_edit.dart';
import 'package:cw_blog/widgets/articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart' as http;
import '../child_page/article/article_data_struct.dart';
import '../frame/value.dart';

class PassagePage extends StatefulWidget {
  const PassagePage({super.key});
  @override
  State<PassagePage> createState() => _PassagePageState();
}

class _PassagePageState extends State<PassagePage> {
  String searchText='';
  String _labelSelection='';
  List<String> labels=[];
  bool isLabelGot=false;//是否已经获取到标签列表
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLabels();
  }
  Future<void> getLabels() async {
    ArticleDataStruct articleDataStruct=ArticleDataStruct(
      'get_label',
    );
    final response = await http.post(
      Uri.parse(articleUrl),
      body: articleDataStruct.encodeToJson(),
    );
    if (response.statusCode == 200){//提交成功
      //此处返回的是一个json的List<String>
      try{
        var decode=jsonDecode(response.body);
        labels=List<String>.from(decode);
      }catch(e){
        labels=[];
      }
      isLabelGot=true;
      setState(() {

      });
    }else{//提交失败
      FlutterToastr.show('无法获取文章标签:${response.body}', duration: 2,context,backgroundColor: Theme.of(context).colorScheme.errorContainer,textStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer));
    }
  }
  List<DropdownMenuItem<String>> buildLabelDropdownMenu(){
    List<DropdownMenuItem<String>> lists=[];
    if(isLabelGot==false){
      return lists;
    }else{
      for(int i=0;i<labels.length;i++){
        lists.add(DropdownMenuItem(child: Text(labels[i]),value: labels[i],),);
      }
      return lists;
    }
  }
  Widget buildArticles(String labelSelection){
    if(labelSelection==''){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-153,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Articles(key: ValueKey(labelSelection),)
          ],
        ),
      );
    }else{
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-153,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Articles(key:ValueKey(labelSelection),articleFilter: ArticleDetail(title: '', author: '', time: DateTime(1970), viewCount: 0, visiblePermission: 0, txt: '', coverPic: '', articleID: 0, label1: labelSelection, label2: '', label3: '', label4: '', label5: '', accountsID: ''))
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RegularHeightSpacing(),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('标签检索    ',style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,fontSize: 16),),
                  DropdownButton<String?>(
                      value: _labelSelection,
                      items: [
                        DropdownMenuItem(child: Text('全部标签'),value: '',),
                      ]+buildLabelDropdownMenu(),
                      onChanged: (String? selection){
                        if(selection!=null){
                          setState(() {
                            _labelSelection=selection;
                          });
                        }
                      }
                  )
                ],
              ),
              RegularHeightSpacing(),
              buildArticles(_labelSelection)
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ArticleEdit()));
              },
              child: Icon(Icons.add_rounded,size: 24,color: Theme.of(context).colorScheme.onPrimaryContainer,),
            ),
          )
        ],
      ),
    );
  }
}
