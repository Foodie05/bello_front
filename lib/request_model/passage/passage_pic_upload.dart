import 'package:json_annotation/json_annotation.dart';
part 'passage_pic_upload.g.dart';

@JsonSerializable()
class PicUploadRequest{
  String token;
  String picData;
  PicUploadRequest({
    required this.token,
    required this.picData
  });
  Map<String,dynamic> toJson()=>_$PicUploadRequestToJson(this);
  factory PicUploadRequest.fromJson(Map<String,dynamic> value)=>_$PicUploadRequestFromJson(value);
}