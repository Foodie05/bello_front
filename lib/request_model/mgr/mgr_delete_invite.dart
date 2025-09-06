import 'package:json_annotation/json_annotation.dart';
part 'mgr_delete_invite.g.dart';

@JsonSerializable()
class DeleteInviteRequest{
  String token;
  String code;
  DeleteInviteRequest({
    required this.token,
    required this.code
  });
  Map<String,dynamic> toJson()=>_$DeleteInviteRequestToJson(this);
  factory DeleteInviteRequest.fromJson(Map<String,dynamic> value)=>_$DeleteInviteRequestFromJson(value);
}