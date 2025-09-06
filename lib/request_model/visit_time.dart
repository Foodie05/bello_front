import 'package:json_annotation/json_annotation.dart';
part 'visit_time.g.dart';

@JsonSerializable()
class VisitRequest{
  bool isDebug;
  VisitRequest({required this.isDebug});
  Map<String,dynamic> toJson()=>_$VisitRequestToJson(this);
  factory VisitRequest.fromJson(Map<String,dynamic> value)=>_$VisitRequestFromJson(value);
}

@JsonSerializable()
class VisitResponse{
  int visitTime;
  int debugTime;
  VisitResponse({required this.visitTime,required this.debugTime});
  Map<String,dynamic> toJson()=>_$VisitResponseToJson(this);
  factory VisitResponse.fromJson(Map<String,dynamic> value)=>_$VisitResponseFromJson(value);
}