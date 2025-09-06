// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_edit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassageEditRequest _$PassageEditRequestFromJson(Map<String, dynamic> json) =>
    PassageEditRequest(
      id: (json['id'] as num).toInt(),
      token: json['token'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
      level: (json['level'] as num).toInt(),
      filter: (json['filter'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PassageEditRequestToJson(PassageEditRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'subject': instance.subject,
      'body': instance.body,
      'level': instance.level,
      'filter': instance.filter,
    };
