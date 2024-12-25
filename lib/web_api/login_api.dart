import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';
import 'package:dongjue_application/globals/user_info.dart';

Dio dio = Dio();

/// 获取数据库列表
Future<Map> getDbNames(String username, String password) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  Response response;
  response = await dio.get("$url/loginapi/getdbnames", queryParameters: {
    "username": username,
    "password": password,
  });
  Map map = response.data as Map;
  return map;
}

//尝试登录或抛出异常
Future<Map> login(String username, String password) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response =
      await dio.get("$url/loginapi/login", queryParameters: {
    "dbName": dbName,
    "username": username,
    "password": password,
  });
  // print(response.data);
  Map map = response.data as Map;
  return map;
}

//检查旧密码是否正确
Future<bool> checkPassword(String oldPassword) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.get("$url/loginapi/checkpassword", queryParameters: {
    "dbName": dbName,
    "userInfoStr": jsonEncode(userInfo),
    "password": oldPassword,
  });
  bool result = response.data as bool;
  return result;
}

