import 'package:json_annotation/json_annotation.dart';
part 'auth_logout.g.dart';
@JsonSerializable()
class LogoutRequest{
  String token;
  LogoutRequest({required this.token});
  Map<String,dynamic> toJson()=>_$LogoutRequestToJson(this);
  factory LogoutRequest.fromJson(Map<String,dynamic> value)=>_$LogoutRequestFromJson(value);
}