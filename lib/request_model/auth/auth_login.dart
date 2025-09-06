import 'package:json_annotation/json_annotation.dart';
part 'auth_login.g.dart';
@JsonSerializable()
class LoginRequest{
  String phoneNumber;
  String email;
  String password;
  LoginRequest({
    required this.phoneNumber,
    required this.email,
    required this.password
  });
  Map<String,dynamic> toJson()=>_$LoginRequestToJson(this);
  factory LoginRequest.fromJson(Map<String,dynamic> value)=>_$LoginRequestFromJson(value);
}