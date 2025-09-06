import 'package:json_annotation/json_annotation.dart';
part 'passage_get.g.dart';

@JsonSerializable()
class PassageGetRequest{
  String token;
  int id;//文章id
  PassageGetRequest({
    required this.token,
    required this.id
  });
  Map<String,dynamic> toJson()=>_$PassageGetRequestToJson(this);
  factory PassageGetRequest.fromJson(Map<String,dynamic> value)=>_$PassageGetRequestFromJson(value);
}