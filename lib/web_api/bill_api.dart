import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';
import 'package:dongjue_application/globals/user_info.dart';
import 'package:dongjue_application/web_api/basic/db_changed_pack.dart';

Dio dio = Dio();

//测试参数
Future<int> parameter_test(String tableName) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/parametertest", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
  });
  print(response.data);
  int refInfo = response.data as int;
  return refInfo;
}

//测试参数
Future<DbChangedPackResult> general_document_save(
    String tableName, dynamic bill, List<dynamic> details) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/generaldocumentsave", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
    "bill": jsonEncode(bill),
    "details": jsonEncode(details),
  });
  print(response.data);
  DbChangedPackResult refInfo = response.data as DbChangedPackResult;
  return refInfo;
}
