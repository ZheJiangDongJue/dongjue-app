import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';
import 'package:dongjue_application/globals/user_info.dart';
import 'package:dongjue_application/web_api/basic/query.dart';

Dio dio = newMethod();

Dio newMethod() {
  var dio = Dio();
  return dio;
}

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

Future<List> GetDataEx(Query query) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getdataex", queryParameters: {
    "dbName": dbName,
    "query": Uri.encodeComponent(jsonEncode(query.toJson())),
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  List list = jsonDecode(refInfo["Data"]);
  return list;
}

//申请新Uid
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

// 通用分页读取可用信息(额外一个字段用于指定要读取的字段)
Future<List> getDataPageWithFields(String tableName, int pageSize, int pageNumber, List<String> fields) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getdatapagewithfields", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "fields": fields.join(","), //拼接fields
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

// 带工艺生成
Future<Map> bringProcessGenerate(String tableName, dynamic bill, dynamic detail) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/bringprocessgenerate", queryParameters: {
    "dbName": dbName,
    "tableName": tableName,
    "user": jsonEncode(userInfo),
    "bill": jsonEncode(bill),
    "detail": jsonEncode(detail),
  });

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

// 检查或创建组装流程卡
Future<Map> checkOrCreateProcessAssemblyFlowDocument(String innerKey) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.get("$url/billapi/checkorcreateprocessassemblyflow", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "innerKey": innerKey,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 获取组装流程卡明细的下一个要接收的工序
Future<Map> getNextReceiveProcessAssemblyFlowDetailQty(int processAssemblyFlowBilld) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getprocessassemblyflownextreceiptdetailqty", queryParameters: {
    "dbName": dbName,
    "billid": processAssemblyFlowBilld,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 获取组装流程卡明细的下一个要完工的工序
Future<Map> getNextCompletionProcessAssemblyFlowDetailQty(int processAssemblyFlowBilld) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio.get("$url/billapi/getprocessassemblyflownextcompletiondetailqty", queryParameters: {
    "dbName": dbName,
    "billid": processAssemblyFlowBilld,
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 批量接收组装流程卡
Future<Map> batchReceiptProcessAssemblyFlowDocument(List<Map> billInfos) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/processassemblyflowbatchreceipt", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "billInfos": jsonEncode(billInfos),
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

// 批量完工组装流程卡
Future<Map> batchCompletionProcessAssemblyFlowDocument(List<Map> billInfos) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/billapi/processassemblyflowbatchcompletion", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "billInfos": jsonEncode(billInfos),
  });
  // print(response.data);
  Map refInfo = response.data as Map;
  return refInfo;
}

class ReceiptInfo {
  int Billid;
  int Employeeid;
  double Qty;

  ReceiptInfo({required this.Billid, required this.Employeeid, required this.Qty});
}

class CompletionInfo {
  int Billid;
  int Employeeid;
  double Qty;

  CompletionInfo({required this.Billid, required this.Employeeid, required this.Qty});
}
