import 'package:json_annotation/json_annotation.dart';
part 'token_request.g.dart';

@JsonSerializable()
class TokenRequest{
  String token;
  TokenRequest({required this.token});
  Map<String,dynamic> toJson()=>_$TokenRequestToJson(this);
  factory TokenRequest.fromJson(Map<String,dynamic> value)=>_$TokenRequestFromJson(value);
}