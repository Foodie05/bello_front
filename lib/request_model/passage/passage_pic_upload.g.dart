// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage_pic_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicUploadRequest _$PicUploadRequestFromJson(Map<String, dynamic> json) =>
    PicUploadRequest(
      token: json['token'] as String,
      picData: json['picData'] as String,
    );

Map<String, dynamic> _$PicUploadRequestToJson(PicUploadRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'picData': instance.picData,
    };
