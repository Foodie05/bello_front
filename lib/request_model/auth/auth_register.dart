import 'package:json_annotation/json_annotation.dart';
part 'auth_register.g.dart';
@JsonSerializable()
class RegisterRequest{
  String phoneNumber;
  String email;
  String password;
  String nickname;
  String invitation;
  String avatar;
  String slogan;
  RegisterRequest({
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.nickname,
    required this.invitation,
    required this.avatar,
    required this.slogan
  });
  Map<String,dynamic> toJson()=>_$RegisterRequestToJson(this);
  factory RegisterRequest.fromJson(Map<String,dynamic> value)=>
      _$RegisterRequestFromJson(value);
}