

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dongjue_application/globals.dart';
import 'package:dongjue_application/globals/user_info.dart';

Dio dio = Dio();

/*
C#代码
  [WebApi(HttpMethodType.POST)]
  [Description("非单据通用删除")]
  public DbChangedPackResult GeneralDeleteRange(string dbName, string user, string tableName, string ids_str)
  {
      var userInfo = user.Deserialize<UserInfo>();
      var entityType = ERP.Db.TypeHelper.TableNameToDbTypes[tableName];
      var model = Server.Core.TypeHelper.EntityTypeToModelMap[entityType];
      var instance = (ISqlSugarModel)Activator.CreateInstance(model, dbName, user);
      var ids = JsonExtension.Deserialize<List<int>>(ids_str);
      var db = SqlSugarHelper.GetDb(dbName);
      var o = db.QueryableByObject(entityType).Where("id IN (@ids)", new { ids = ids }).ToList();
      return instance?.DeleteRange(o);
  }
*/

Future<Map> generalDeleteRange(String tableName, List<int> ids) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/generalentityapi/generaldeleterange", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "tableName": tableName,
    "ids_str": jsonEncode(ids),
  });
  Map map = response.data as Map;
  return map;
}

/*
C#代码
[WebApi(HttpMethodType.POST)]
        [Description("检测是否能删除")]
        public DbChangedPackResult CheckCanRemove(string dbName, string tableName, string ids_str)
        {
            var pack = new DbChangedPack();
            var ids = JsonExtension.Deserialize<List<int>>(ids_str);
            var db = SqlSugarHelper.GetDb(dbName);
            var type = TypeHelper.TableNameToDbTypes[tableName];
            var o = db.QueryableByObject(type).Where("id IN (@ids)", new { ids = ids }).ToList();
            if (o is IList list)
            {
                var entitys = list.Cast<object>().ToList();
                if (!ReferenceManager.Instance.CanRemoveRange(dbName, entitys, out var referenceObjects))
                {
                    pack.Objects["引用拦截"] = referenceObjects;
                    pack.Error(new Exception(ReferenceManager.Instance.GetReferenceMessage(referenceObjects)));
                }
            }

            return pack.GetResult();
        }
*/

Future<Map> checkCanRemove(String tableName, List<int> ids) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  UserInfo userInfo = GlobalData().user_info;
  Response response;
  response = await dio.post("$url/generalentityapi/checkcanremove", queryParameters: {
    "dbName": dbName,
    "user": jsonEncode(userInfo),
    "tableName": tableName,
    "ids_str": jsonEncode(ids),
  });
  Map map = response.data as Map;
  return map;
}

