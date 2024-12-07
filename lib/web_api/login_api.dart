import 'dart:async';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();

//尝试登录或抛出异常
Future<Map> login(String username, String password) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response =
      await dio.get("$url/androidapiserver/loginforapp", queryParameters: {
    "dbName": dbName,
    "username": username,
    "password": password,
  });
  print(response.data);
  Map map = response.data as Map;
  return map;
}