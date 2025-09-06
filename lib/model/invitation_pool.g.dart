// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationPool _$InvitationPoolFromJson(Map<String, dynamic> json) =>
    InvitationPool(
      invitationCode: json['invitationCode'] as String,
      level: (json['level'] as num?)?.toInt() ?? 3,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$InvitationPoolToJson(InvitationPool instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invitationCode': instance.invitationCode,
      'level': instance.level,
    };
