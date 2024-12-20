import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';
import 'package:dongjue_application/globals/user_info.dart';
import 'package:dongjue_application/web_api/basic/db_changed_pack.dart';

Dio dio = Dio();

//测试参数
Future<int> parameterTest(String tableName) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/parametertest", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
  });
  // print(response.data);
  int refInfo = response.data as int;
  return refInfo;
}

//测试参数
Future<int> getNewUid() async {
  String url = GlobalData().web_api_config.WebApiUrl;
  Response response;
  response = await dio.post("$url/billapi/getnewuid");
  // print(response.data);
  int refInfo = response.data as int;
  return refInfo;
}

// 通用分页读取可用信息
Future<List> getDataPage(String tableName, int pageSize, int pageNumber) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getdatapage", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "pageSize": pageSize,
    "pageNumber": pageNumber,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"]);
  return list;
}

// 通用读取信息
Future<List> getDataUseIds(String tableName, List<int> ids) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getdatauseids", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "ids": jsonEncode(ids),
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"]);
  return list;
}

// 单据通用获取前单
Future<Map?> getPrevBill(String tableName, int billid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getpreviousbill", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "billid": billid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"]);
  if (list.isNotEmpty) {
    return list[0];
  }
  return null;
}

// 单据通用获取后单
Future<Map?> getNextBill(String tableName, int billid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getnextbill", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "billid": billid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"] ?? "[]");
  if (list.isNotEmpty) {
    return list[0];
  }
  return null;
}

// 单据通用获取明细
Future<List> getBillDetail(String tableName, int billid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getbilldetails", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "billid": billid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"]);
  return list;
}

// 单据通用保存
Future<Map> generalBillSave(String tableName, dynamic bill, List<dynamic> details) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/generalbillsave", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
    "bill": jsonEncode(bill),
    "details": jsonEncode(details),
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 单据通用删除
Future<Map> generalBillDelete(String tableName, int billid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/generalbilldelete", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
    "billid": billid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 单据通用审批
Future<Map> generalBillApproval(String tableName, int billid, bool b) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/generalbillapproval", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
    "billid": billid,
    "b": b,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 接收组装流程卡
Future<Map> receiveProcessAssemblyFlowDocument(int processAssemblyFlowDetailid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/receiveprocessassemblyflowdocument", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "processAssemblyFlowDetailid": processAssemblyFlowDetailid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}


// 完工组装流程卡
Future<Map> completeProcessAssemblyFlowDocument(int processAssemblyFlowDetailid) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/completeprocessassemblyflowdocument", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "processAssemblyFlowDetailid": processAssemblyFlowDetailid,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}
