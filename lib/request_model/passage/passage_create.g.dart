// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassageCreateRequest _$PassageCreateRequestFromJson(
  Map<String, dynamic> json,
) => PassageCreateRequest(
  token: json['token'] as String,
  subject: json['subject'] as String,
  body: json['body'] as String,
  filter: (json['filter'] as List<dynamic>).map((e) => e as String).toList(),
  level: (json['level'] as num).toInt(),
);

Map<String, dynamic> _$PassageCreateRequestToJson(
  PassageCreateRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'subject': instance.subject,
  'body': instance.body,
  'filter': instance.filter,
  'level': instance.level,
};
