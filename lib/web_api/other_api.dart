import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';
import 'package:dongjue_application/globals/user_info.dart';

Dio dio = Dio();

//修改密码
Future<Map> changePassword(String username, String oldPwd, String newPwd) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/loginapi/changepassword", queryParameters: {
    "dbName": dbName,
    "userInfoStr": jsonEncode(userInfo),
    "oldPwd": oldPwd,
    "newPwd": newPwd,
  });
  // print(response.data);
  Map map = response.data as Map;
  return map;
}
