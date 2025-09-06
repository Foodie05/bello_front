import 'package:json_annotation/json_annotation.dart';
part 'passage_search.g.dart';

@JsonSerializable()
class PassageSearchRequest{
  String token;
  String nickname;
  String keyword;
  List<String> filter;
  PassageSearchRequest({
    required this.token,
    required this.nickname,
    required this.keyword,
    required this.filter
  });
  Map<String,dynamic> toJson()=>_$PassageSearchRequestToJson(this);
  factory PassageSearchRequest.fromJson(Map<String,dynamic> value)=>_$PassageSearchRequestFromJson(value);
}