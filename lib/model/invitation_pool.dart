import 'package:json_annotation/json_annotation.dart';
part 'invitation_pool.g.dart';

@JsonSerializable()
class InvitationPool{
  int id=0;
  String invitationCode;
  int level=3;
  InvitationPool({
    required this.invitationCode,
    this.level=3
  });
  Map<String,dynamic> toJson()=>_$InvitationPoolToJson(this);
  factory InvitationPool.fromJson(Map<String,dynamic> value)=>_$InvitationPoolFromJson(value);
}