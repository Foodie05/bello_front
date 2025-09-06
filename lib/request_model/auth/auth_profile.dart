import 'package:json_annotation/json_annotation.dart';
part 'auth_profile.g.dart';
@JsonSerializable()
class ProfileRequest{
  String token;
  ProfileRequest({
    this.token=''
  });
  Map<String,dynamic> toJson()=>_$ProfileRequestToJson(this);
  factory ProfileRequest.fromJson(Map<String,dynamic> value)=>_$ProfileRequestFromJson(value);
}