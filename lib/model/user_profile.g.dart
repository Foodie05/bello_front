// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  phoneNumber: json['phoneNumber'] as String? ?? '',
  email: json['email'] as String? ?? '',
  nickname: json['nickname'] as String? ?? '',
  avatar: json['avatar'] as String? ?? '',
  slogan: json['slogan'] as String? ?? '',
  level: (json['level'] as num?)?.toInt() ?? 3,
  passwordHash: json['passwordHash'] as String,
  salt: json['salt'] as String,
)..id = (json['id'] as num).toInt();

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'slogan': instance.slogan,
      'passwordHash': instance.passwordHash,
      'salt': instance.salt,
      'level': instance.level,
    };
