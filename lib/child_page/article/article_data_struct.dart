import 'dart:convert';

class ArticleDetail{
  String title;
  String author;
  DateTime time;
  int viewCount;
  int visiblePermission;
  String txt;
  String coverPic;
  int articleID;
  String label1;
  String label2;
  String label3;
  String label4;
  String label5;
  String accountsID;
  ArticleDetail({
    required this.title,
    required this.author,
    required this.time,
    required this.viewCount,
    required this.visiblePermission,
    required this.txt,
    required this.coverPic,
    required this.articleID,
    required this.label1,
    required this.label2,
    required this.label3,
    required this.label4,
    required this.label5,
    required this.accountsID
  });

  Map<String,String> encodeToJson(){
    Map<String,String> map={};
    map.addAll({'title':title});
    map.addAll({'author':author});
    map.addAll({'time': time.toString()});
    map.addAll({'viewCount':viewCount.toString()});
    map.addAll({'visiblePermission':visiblePermission.toString()});
    map.addAll({'txt':txt});
    map.addAll({'coverPic':coverPic});
    map.addAll({'articleID':articleID.toString()});
    map.addAll({'label1':label1});
    map.addAll({'label2':label2});
    map.addAll({'label3':label3});
    map.addAll({'label4':label4});
    map.addAll({'label5':label5});
    map.addAll({'accountsID':accountsID});
    return map;
  }

  factory ArticleDetail.decodeToData(String map){
    Map<String,String> mapInfo={};
    try{
      var data=jsonDecode(map);
      mapInfo=Map<String,String>.from(data);
    }catch(e) {
      return ArticleDetail(title: 'failed to decode article details',
          author: 'error',
          time: DateTime.now(),
          viewCount: 0,
          visiblePermission: 0,
          txt: 'error',
          coverPic: 'error',
          articleID: 0,
          label1: '',
          label2: '',
          label3: '',
          label4: '',
          label5: '',
          accountsID: ''
      );
    }
    String title;
    String author;
    DateTime time;
    int viewCount;
    int visiblePermission;
    String txt;
    String coverPic;
    int articleID;
    String label1;
    String label2;
    String label3;
    String label4;
    String label5;
    String accountsID;
    title=mapInfo['title']??'';
    author=mapInfo['author']??'';
    if(mapInfo.containsKey('time')) {
      time=DateTime.tryParse(mapInfo['time']!)??DateTime(1970);
    }else{
      time=DateTime(1970);
    }
    if(mapInfo.containsKey('viewCount')){
      viewCount=int.tryParse(mapInfo['viewCount']!)??0;
    }else{
      viewCount=0;
    }
    if(mapInfo.containsKey('visiblePermission')){
      visiblePermission=int.tryParse(mapInfo['visiblePermission']!)??0;
    }else{
      visiblePermission=0;
    }
    txt=mapInfo['txt']??'';
    coverPic=mapInfo['coverPic']??'';
    if(mapInfo.containsKey('articleID')){
      articleID=int.tryParse(mapInfo['articleID']!)??0;
    }else{
      articleID=0;
    }
    label1=mapInfo['label1']??'';
    label2=mapInfo['label2']??'';
    label3=mapInfo['label3']??'';
    label4=mapInfo['label4']??'';
    label5=mapInfo['label5']??'';
    accountsID=mapInfo['accountsID']??'';
    return ArticleDetail(title: title, author: author, time: time, viewCount: viewCount, visiblePermission: visiblePermission, txt: txt, coverPic: coverPic, articleID: articleID, label1: label1, label2: label2, label3: label3, label4: label4, label5: label5,accountsID: accountsID);
  }
}
class ArticleDataStruct{
  String msg;
  String? _accountsID;
  String? _passwdMd5;
  String? _passwdSha256;
  List<ArticleDetail>? _articles;
  ArticleDataStruct(
      this.msg,
      {
        String ?accountsID,
        String ?passwdMd5,
        String ?passwdSha256,
        List<ArticleDetail> ?articles
      }
      ){
    _accountsID=accountsID;
    _passwdMd5=passwdMd5;
    _passwdSha256=passwdSha256;
    _articles=articles;
  }

  String get accountsID=>_accountsID??'';
  String get passwdMd5=>_passwdMd5??'';
  String get passwdSha256=>_passwdSha256??'';
  List<ArticleDetail> get articleDetail=>_articles??[];

  set accountsID(String? accountsID)=>_accountsID=accountsID;
  set passwdMd5(String? passwdMd5)=>_passwdMd5=passwdMd5;
  set passwdSha256(String? passwdSha256)=>_passwdSha256=passwdSha256;
  set articles(List<ArticleDetail>? articles)=>_articles=articles;

  String encodeToJson(){
    Map<String,String> mapInfo={};
    mapInfo.addAll({'msg':msg});
    if(_accountsID!=null){
      mapInfo.addAll({'accountsID':_accountsID!});
    }
    if(_passwdMd5!=null){
      mapInfo.addAll({'passwdMd5':_passwdMd5!});
    }
    if(_passwdSha256!=null){
      mapInfo.addAll({'passwdSha256':_passwdSha256!});
    }
    var articles=_articles;
    if(_articles!=null){
      mapInfo.addAll({'articles':jsonEncode(articles!.map((article) => article.encodeToJson()).toList())});
    }
    return jsonEncode(mapInfo);
  }

  factory ArticleDataStruct.decodeToData(String? map){
    ArticleDataStruct articleDataStruct=ArticleDataStruct('');
    if(map==null){
      articleDataStruct.msg='Failed to decode json: map is null';
      return articleDataStruct;
    }
    Map<String,String> mapInfo;
    try{
      var decodeData=jsonDecode(map);
      mapInfo=Map<String,String>.from(decodeData);
    }catch(e){
      articleDataStruct.msg='Failed to decode json:Invalid map data';
      return articleDataStruct;
    }
    if(mapInfo.containsKey('msg')){
      articleDataStruct.msg=mapInfo['msg']!;
    }
    if(mapInfo.containsKey('accountsID')){
      articleDataStruct.accountsID=mapInfo['accountsID']!;
    }
    if(mapInfo.containsKey('passwdMd5')){
      articleDataStruct.passwdMd5=mapInfo['passwdMd5']!;
    }
    if(mapInfo.containsKey('passwdSha256')){
      articleDataStruct.passwdSha256=mapInfo['passwdSha256']!;
    }
    if(mapInfo.containsKey('articles')){

      List<dynamic> decodedList = jsonDecode(mapInfo['articles']!); // 假设传入的 JSON 是一个列表
      List<ArticleDetail> articleList =decodedList.map((item) => ArticleDetail.decodeToData(jsonEncode(item))).toList();
      articleDataStruct.articles=articleList;
    }
    return articleDataStruct;
  }
}