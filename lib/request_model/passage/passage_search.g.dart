// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassageSearchRequest _$PassageSearchRequestFromJson(
  Map<String, dynamic> json,
) => PassageSearchRequest(
  token: json['token'] as String,
  nickname: json['nickname'] as String,
  keyword: json['keyword'] as String,
  filter: (json['filter'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PassageSearchRequestToJson(
  PassageSearchRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'nickname': instance.nickname,
  'keyword': instance.keyword,
  'filter': instance.filter,
};
