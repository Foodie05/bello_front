// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mgr_delete_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteInviteRequest _$DeleteInviteRequestFromJson(Map<String, dynamic> json) =>
    DeleteInviteRequest(
      token: json['token'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$DeleteInviteRequestToJson(
  DeleteInviteRequest instance,
) => <String, dynamic>{'token': instance.token, 'code': instance.code};
