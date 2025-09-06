// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mgr_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteRequest _$InviteRequestFromJson(Map<String, dynamic> json) =>
    InviteRequest(
      token: json['token'] as String,
      level: (json['level'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$InviteRequestToJson(InviteRequest instance) =>
    <String, dynamic>{'token': instance.token, 'level': instance.level};
