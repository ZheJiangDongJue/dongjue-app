// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: (json['id'] as num).toInt(),
      UserName: json['UserName'] as String,
      Name: json['Name'] as String,
      Jobid: (json['Jobid'] as num).toInt(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'UserName': instance.UserName,
      'Name': instance.Name,
      'Jobid': instance.Jobid,
    };
