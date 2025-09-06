// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
    };
