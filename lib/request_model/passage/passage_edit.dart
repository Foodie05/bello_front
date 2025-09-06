import 'package:json_annotation/json_annotation.dart';
part 'passage_edit.g.dart';

@JsonSerializable()
class PassageEditRequest{
  int id;
  String token;
  String subject;
  String body;
  int level;
  List<String> filter;
  PassageEditRequest({
    required this.id,
    required this.token,
    required this.subject,
    required this.body,
    required this.level,
    required this.filter
  });
  Map<String,dynamic> toJson()=>_$PassageEditRequestToJson(this);
  factory PassageEditRequest.fromJson(Map<String,dynamic> value)=>_$PassageEditRequestFromJson(value);
}