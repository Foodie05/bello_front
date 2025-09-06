import 'package:json_annotation/json_annotation.dart';
part 'passage_delete.g.dart';

@JsonSerializable()
class PassageDeleteRequest{
  String token;
  int id;//文章id
  PassageDeleteRequest({
    required this.token,
    required this.id
  });
  Map<String,dynamic> toJson()=>_$PassageDeleteRequestToJson(this);
  factory PassageDeleteRequest.fromJson(Map<String,dynamic> value)=>_$PassageDeleteRequestFromJson(value);
}