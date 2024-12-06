import 'dart:async';
import 'dart:convert';

import 'package:dongjue_application/globals.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();

//尝试登录或抛出异常
Future<Map> login(String username, String password) async {
  String url = GlobalData().web_api_config.WebApiUrl;
  String dbName = GlobalData().db_config.DbName;
  Response response;
  response = await dio
      .get("http://$url/androidapiserver/loginforapp", queryParameters: {
    "dbName": dbName,
    "username": username,
    "password": password,
  });
  print(response.data);
  Map map = response.data as Map;
  return map;
}



// class Album {
//   final int userId;
//   final int id;
//   final String title;

//   const Album({
//     required this.userId,
//     required this.id,
//     required this.title,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'userId': int userId,
//         'id': int id,
//         'title': String title,
//       } =>
//         Album(
//           userId: userId,
//           id: id,
//           title: title,
//         ),
//       _ => throw const FormatException('Failed to load album.'),
//     };
//   }
// }
