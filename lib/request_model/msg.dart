import 'package:json_annotation/json_annotation.dart';
part 'msg.g.dart';

@JsonSerializable()
class Msg{
  String msg;
  Msg({required this.msg});
  Map<String,dynamic> toJson()=>_$MsgToJson(this);
  factory Msg.fromJson(Map<String,dynamic> value)=>_$MsgFromJson(value);
}