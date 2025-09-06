// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passage _$PassageFromJson(Map<String, dynamic> json) => Passage(
  belongTo: (json['belongTo'] as num).toInt(),
  subject: json['subject'] as String,
  text: json['text'] as String,
  datetime: DateTime.parse(json['datetime'] as String),
  labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
  viewTime: (json['viewTime'] as num).toInt(),
  author: json['author'] as String,
  level: (json['level'] as num?)?.toInt() ?? 3,
)..id = (json['id'] as num).toInt();

Map<String, dynamic> _$PassageToJson(Passage instance) => <String, dynamic>{
  'id': instance.id,
  'belongTo': instance.belongTo,
  'subject': instance.subject,
  'text': instance.text,
  'datetime': instance.datetime.toIso8601String(),
  'labels': instance.labels,
  'viewTime': instance.viewTime,
  'level': instance.level,
  'author': instance.author,
};
