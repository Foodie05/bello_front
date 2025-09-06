// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassageGetRequest _$PassageGetRequestFromJson(Map<String, dynamic> json) =>
    PassageGetRequest(
      token: json['token'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$PassageGetRequestToJson(PassageGetRequest instance) =>
    <String, dynamic>{'token': instance.token, 'id': instance.id};
