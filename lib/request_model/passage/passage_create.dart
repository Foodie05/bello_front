import 'package:json_annotation/json_annotation.dart';
part 'passage_create.g.dart';

@JsonSerializable()
class PassageCreateRequest{
  String token;
  String subject;
  String body;
  List<String> filter;
  int level;
  PassageCreateRequest({
    required this.token,
    required this.subject,
    required this.body,
    required this.filter,
    required this.level
  });
  Map<String,dynamic> toJson()=>_$PassageCreateRequestToJson(this);
  factory PassageCreateRequest.fromJson(Map<String,dynamic> value)=>_$PassageCreateRequestFromJson(value);
}