import 'package:json_annotation/json_annotation.dart';
part 'passage.g.dart';
@JsonSerializable()
class Passage{
  int id=0;

  int belongTo;
  String subject;
  String text;
  DateTime datetime;
  List<String> labels;
  int viewTime;
  int level;
  String author;

  Passage({
    required this.belongTo,
    required this.subject,
    required this.text,
    required this.datetime,
    required this.labels,
    required this.viewTime,
    required this.author,
    this.level=3
  });

  Map<String,dynamic> toJson()=>_$PassageToJson(this);
  factory Passage.fromJson(Map<String,dynamic> value)=>_$PassageFromJson(value);
}