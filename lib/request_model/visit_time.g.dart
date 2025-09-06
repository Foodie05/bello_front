// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitRequest _$VisitRequestFromJson(Map<String, dynamic> json) =>
    VisitRequest(isDebug: json['isDebug'] as bool);

Map<String, dynamic> _$VisitRequestToJson(VisitRequest instance) =>
    <String, dynamic>{'isDebug': instance.isDebug};

VisitResponse _$VisitResponseFromJson(Map<String, dynamic> json) =>
    VisitResponse(
      visitTime: (json['visitTime'] as num).toInt(),
      debugTime: (json['debugTime'] as num).toInt(),
    );

Map<String, dynamic> _$VisitResponseToJson(VisitResponse instance) =>
    <String, dynamic>{
      'visitTime': instance.visitTime,
      'debugTime': instance.debugTime,
    };
