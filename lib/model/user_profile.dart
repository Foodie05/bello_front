import 'package:json_annotation/json_annotation.dart';
part 'user_profile.g.dart';
//User level
//1-admin
//2-author
//3-visitor
//4-blacklist
@JsonSerializable()
class UserProfile{
  UserProfile({
    this.phoneNumber='',
    this.email='',
    this.nickname='',
    this.avatar='',
    this.slogan='',
    this.level=3,
    required this.passwordHash,
    required this.salt
  });
  int id=0;
  String phoneNumber;
  String email;
  String nickname;
  String avatar;
  String slogan;
  String passwordHash;
  String salt;
  int level;
  factory UserProfile.fromJson(Map<String,dynamic> value)=>_$UserProfileFromJson(value);
  Map<String,dynamic> toJson()=>_$UserProfileToJson(this);
  void privateWash(){
    passwordHash='';
    salt='';
  }
}