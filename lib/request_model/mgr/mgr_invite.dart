import 'package:json_annotation/json_annotation.dart';
part 'mgr_invite.g.dart';
@JsonSerializable()
class InviteRequest{
  String token;
  int level=3;
  InviteRequest({
    required this.token,
    this.level=3
  });
  Map<String,dynamic> toJson()=>_$InviteRequestToJson(this);
  factory InviteRequest.fromJson(Map<String,dynamic> value)=>_$InviteRequestFromJson(value);
}