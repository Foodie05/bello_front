import 'dart:convert';
import 'dart:core';

class AccountDataStruct{
  //必须要有的信息
  late String _msg;//来回传信息必须有这个
  late int _statusCode;//来回传信息要有状态码，遵循http状态码规则
  //通常需要的是这些东西：
  String? _accountsID;
  String? _passwdMd5;
  String? _passwdSha256;
  //可能需要的管理员信息：
  String? _adminAccountsID;
  String? _adminPasswdMd5;
  String? _adminPasswdSha256;
  //可能额外需要的信息：
  List? _accountList;//账户列表，管理员做账户管理时使用
  String? _phoneNumber;
  DateTime? _registerTime;
  String? _nickName;
  String? _gender;
  String? _email;
  String? _signature;//用户个性签名
  int? _accountPermission;
  int? _accountLevel;
  bool? _isInit;
  int? _loginMode;
  String? _newPasswdMd5;
  String? _newPasswdSha256;
  String? _invitationCode;
  //以上是数据结构

  AccountDataStruct({//构造函数
    required String msg,
    int statusCode=200,//默认是200
    String? accountsID,
    String ?passwdMd5,
    String? passwdSha256,
    String? adminAccountsID,
    String? adminPasswdMd5,
    String? adminPasswdSha256,
    List? accountList,
    String? phoneNumber,
    DateTime? registerTime,
    String? nickName,
    String? gender,
    String? email,
    String? signature,
    int? accountPermission,
    int? accountLevel,
    bool? isInit,
    int? loginMode,
    String? newPasswdMd5,
    String? newPasswdSha256,
    String? invitationCode
  }){
    _msg=msg;
    _statusCode=statusCode;
    _accountsID=accountsID;
    _passwdMd5=passwdMd5;
    _passwdSha256=passwdSha256;
    _adminAccountsID=adminAccountsID;
    _adminPasswdMd5=adminPasswdMd5;
    _adminPasswdSha256=adminPasswdSha256;
    _accountList=accountList;
    _phoneNumber=phoneNumber;
    _registerTime=registerTime;
    _nickName=nickName;
    _gender=gender;
    _email=email;
    _signature=signature;
    _accountPermission=accountPermission;
    _accountLevel=accountLevel;
    _isInit=isInit;
    _loginMode=loginMode;
    _newPasswdMd5=newPasswdMd5;
    _newPasswdSha256=newPasswdSha256;
    _invitationCode=invitationCode;
  }

  //getter
  String get msg=>_msg;
  int get statusCode=>_statusCode;
  String get accountsID=>_accountsID??'';
  String get passwdMd5=>_passwdMd5??'';
  String get passwdSha256=>_passwdSha256??'';
  String get adminAccountsID=>_adminAccountsID??'';
  String get adminPasswdMd5=>_adminPasswdMd5??'';
  String get adminPasswdSha256=>_adminPasswdSha256??'';
  List get accountList=>_accountList??[];
  String get phoneNumber=>_phoneNumber??'';
  DateTime get registerTime=>_registerTime??DateTime(1970);
  String get nickName=>_nickName??'';
  String get gender=>_gender??'';
  String get email=>_email??'';
  String get signature=>_signature??'';
  int get accountPermission=>_accountPermission??5;//不可以默认赋0,因为0是终极管理
  int get accountLevel=>_accountLevel??0;
  bool get isInit=>_isInit??false;
  int get loginMode=>_loginMode??0;
  String get newPasswdMd5=>_newPasswdMd5??'';
  String get newPasswdSha256=>_newPasswdSha256??'';
  String get invitationCode=>_invitationCode??'';

  //setter
  set msg(String? msg)=>_msg=msg??'';
  set statusCode(int? statusCode)=>_statusCode=statusCode??404;//默认是不通过
  set accountsID(String? accountsID)=>_accountsID=accountsID??'';
  set passwdMd5(String? passwdMd5)=>_passwdMd5=passwdMd5??'';
  set passwdSha256(String? passwdSha256)=>_passwdSha256=passwdSha256??'';
  set adminAccountsID(String? adminAccountsID)=>_adminAccountsID=adminAccountsID??'';
  set adminPasswdMd5(String? adminPasswdMd5)=>_adminPasswdMd5=adminPasswdMd5??'';
  set adminPasswdSha256(String? adminPasswdSha256)=>_adminPasswdSha256=adminPasswdSha256??'';
  set accountList(List? accountList)=>_accountList=accountList??[];
  set phoneNumber(String? phoneNumber)=>_phoneNumber=phoneNumber??'';
  set registerTime(DateTime? registerTime)=>_registerTime=registerTime??DateTime(1970);
  set nickName(String? nickName)=>_nickName=nickName??'';
  set gender(String? gender)=>_gender=gender??'';
  set email(String? email)=>_email=email??'';
  set signature(String? signature)=>_signature??'';
  set accountPermission(int? accountPermission)=>_accountPermission=accountPermission??5;//不可以默认赋0,因为0是终极管理
  set accountLevel(int? accountLevel)=>_accountLevel=accountLevel??0;
  set isInit(bool? isInit)=>_isInit=isInit??false;
  set loginMode(int? loginMode)=>_loginMode=loginMode??0;
  set newPasswdMd5(String? newPasswdMd5)=>_newPasswdMd5=newPasswdMd5??'';
  set newPasswdSha256(String? newPasswdSha256)=>_newPasswdSha256=newPasswdSha256??'';
  set invitationCode(String? invitationCode)=>_invitationCode=invitationCode??'';

  //functions
  String encodeToJson(){
    Map<String,String> infoMap={};
    infoMap.addAll({'msg':_msg});
    infoMap.addAll({'statusCode':_statusCode.toString()});
    if(_accountsID!=null){
      infoMap.addAll({'accountsID': _accountsID!});
    }
    if(_passwdMd5!=null){
      infoMap.addAll({'passwdMd5':_passwdMd5!});
    }
    if(_passwdSha256!=null){
      infoMap.addAll({'passwdSha256':_passwdSha256!});
    }
    if(_adminAccountsID!=null){
      infoMap.addAll({'adminAccountsID':_adminAccountsID!});
    }
    if(_adminPasswdMd5!=null){
      infoMap.addAll({'adminPasswdMd5':_adminPasswdMd5!});
    }
    if(_adminPasswdSha256!=null){
      infoMap.addAll({'adminPasswdSha256':_adminPasswdSha256!});
    }
    if(_accountList!=null){
      infoMap.addAll({'accountList':jsonEncode(accountList)});
    }
    if(_phoneNumber!=null){
      infoMap.addAll({'phoneNumber':_phoneNumber!});
    }
    if(_registerTime!=null){
      infoMap.addAll({'registerTime':_registerTime!.toString()});
    }
    if(_nickName!=null){
      infoMap.addAll({'nickName':_nickName!});
    }
    if(_gender!=null){
      infoMap.addAll({'gender':_gender!});
    }
    if(_email!=null){
      infoMap.addAll({'email':_email!});
    }
    if(_signature!=null){
      infoMap.addAll({'signature':_signature!});
    }
    if(_accountPermission!=null){
      infoMap.addAll({'accountPermission':_accountPermission!.toString()});
    }
    if(_accountLevel!=null){
      infoMap.addAll({'accountLevel':_accountLevel!.toString()});
    }
    if(_isInit!=null){
      infoMap.addAll({'isInit':_isInit.toString()});
    }
    if(_loginMode!=null){
      infoMap.addAll({'loginMode':_loginMode!.toString()});
    }
    if(_newPasswdMd5!=null){
      infoMap.addAll({'newPasswdMd5':_newPasswdMd5!});
    }
    if(_newPasswdSha256!=null){
      infoMap.addAll({'newPasswdSha256':_newPasswdSha256!});
    }
    if(_invitationCode!=null){
      infoMap.addAll({'invitationCode':_invitationCode!});
    }
    return jsonEncode(infoMap);
  }


  factory AccountDataStruct.decodeToData(String? dataSource){
    if(dataSource==null){
      return AccountDataStruct(msg: 'dataSource is null');
    }
    Map<String,String> infoMap;
    try{
      var decodeJson=jsonDecode(dataSource);
      infoMap=Map<String,String>.from(decodeJson);
    }catch(e){
      return AccountDataStruct(msg: 'decodeToData failed',statusCode: 404);
    }
    String msg;
    int ?statusCode;//默认是200
    String? accountsID;
    String ?passwdMd5;
    String? passwdSha256;
    String? adminAccountsID;
    String? adminPasswdMd5;
    String? adminPasswdSha256;
    List? accountList;
    String? phoneNumber;
    DateTime? registerTime;
    String? nickName;
    String? gender;
    String? email;
    String? signature;
    int? accountPermission;
    int? accountLevel;
    bool? isInit;
    int ?loginMode;
    String? newPasswdMd5;
    String? newPasswdSha256;
    String ?invitationCode;
    if(infoMap.containsKey('msg')){
      msg=infoMap['msg']!;
    }else{
      return AccountDataStruct(msg: 'decodeToData failed',statusCode: 404);
    }
    statusCode=infoMap.containsKey('statusCode')?int.tryParse(infoMap['statusCode']!):null;
    accountsID=infoMap.containsKey('accountsID')?infoMap['accountsID']!:null;
    passwdMd5=infoMap.containsKey('passwdMd5')?infoMap['passwdMd5']!:null;
    passwdSha256=infoMap.containsKey('passwdSha256')?infoMap['passwdSha256']:null;
    adminAccountsID=infoMap.containsKey('adminAccountsID')?infoMap['adminAccountsID']!:null;
    adminPasswdMd5=infoMap.containsKey('adminPasswdMd5')?infoMap['adminPasswdMd5']!:null;
    adminPasswdSha256=infoMap.containsKey('adminPasswdSha256')?infoMap['adminPasswdSha256']!:null;
    try {
      accountList = infoMap.containsKey('accountList')
          ? List<Map<String, String>>.from(jsonDecode(infoMap['accountList']!))
          : null;
    }finally{}
    phoneNumber=infoMap.containsKey('phoneNumber')?infoMap['phoneNumber']!:null;
    registerTime=infoMap.containsKey('registerTime')?DateTime.tryParse(infoMap['registerTime']!):null;
    nickName=infoMap.containsKey('nickName')?infoMap['nickName']!:null;
    gender=infoMap.containsKey('gender')?infoMap['gender']!:null;
    email=infoMap.containsKey('email')?infoMap['email']!:null;
    signature=infoMap.containsKey('signature')?infoMap['signature']!:null;
    accountPermission=infoMap.containsKey('accountPermission')?int.tryParse(infoMap['accountPermission']!):null;
    accountLevel=infoMap.containsKey('accountLevel')?int.tryParse(infoMap['accountLevel']!):null;
    isInit=infoMap.containsKey('isInit')?bool.tryParse(infoMap['isInit']!):null;
    loginMode=infoMap.containsKey('loginMode')?int.tryParse(infoMap['loginMode']!):null;
    newPasswdMd5=infoMap.containsKey('newPasswdMd5')?infoMap['newPasswdMd5']!:null;
    newPasswdSha256=infoMap.containsKey('newPasswdSha256')?infoMap['newPasswdSha256']!:null;
    invitationCode=infoMap.containsKey('invitationCode')?infoMap['invitationCode']!:null;
    return AccountDataStruct(
        msg: msg,
        statusCode: statusCode??200,
        accountsID: accountsID,
        passwdMd5: passwdMd5,
        passwdSha256: passwdSha256,
        adminAccountsID: adminAccountsID,
        adminPasswdMd5: adminPasswdMd5,
        adminPasswdSha256: adminPasswdSha256,
        accountList: accountList,
        phoneNumber: phoneNumber,
        registerTime: registerTime,
        nickName: nickName,
        gender: gender,
        email: email,
        signature: signature,
        accountPermission: accountPermission,
        accountLevel: accountLevel,
        isInit: isInit,
        loginMode: loginMode,
        newPasswdMd5: newPasswdMd5,
        newPasswdSha256: newPasswdSha256,
        invitationCode: invitationCode
    );
  }
}