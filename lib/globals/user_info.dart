import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'id')
  int id = 0;
  @JsonKey(name: 'UserName')
  String UserName = "";
  @JsonKey(name: 'Name')
  String Name = "";
  @JsonKey(name: 'Jobid')
  int Jobid = 0;

  UserInfo({required this.id, required this.UserName, required this.Name, required this.Jobid});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
