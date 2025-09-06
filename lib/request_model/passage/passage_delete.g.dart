// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_delete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassageDeleteRequest _$PassageDeleteRequestFromJson(
  Map<String, dynamic> json,
) => PassageDeleteRequest(
  token: json['token'] as String,
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$PassageDeleteRequestToJson(
  PassageDeleteRequest instance,
) => <String, dynamic>{'token': instance.token, 'id': instance.id};
