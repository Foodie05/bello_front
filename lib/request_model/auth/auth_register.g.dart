// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
      invitation: json['invitation'] as String,
      avatar: json['avatar'] as String,
      slogan: json['slogan'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
      'nickname': instance.nickname,
      'invitation': instance.invitation,
      'avatar': instance.avatar,
      'slogan': instance.slogan,
    };
