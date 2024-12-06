import 'package:shared_preferences/shared_preferences.dart';

import './globals.dart';

//这是一个实现了持久化的设置代码文件

//保存设置
Future<void> saveSettings(
    bool notificationsEnabled, String webApiUrl, String dbName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notifications', notificationsEnabled);//这个是设置通知是否开启(目前没有实装任何逻辑)
  await prefs.setString("WebApiConfig_WebApiUrl", webApiUrl);//这个是设置webApi的地址
  await prefs.setString("DbConfig_DbName", dbName);//这个是设置数据库的名字
}

//读取设置
Future<void> loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('notifications') ?? true;
  final String webApiUrl =
      prefs.getString("WebApiConfig_WebApiUrl") ?? '192.168.3.250:7790';
  final String dbName = prefs.getString("DbConfig_DbName") ?? 'PEM6';
  // // 使用加载的设置
  print('是否通知: $notificationsEnabled');
  print("WebApiUrl: $webApiUrl");
  print("数据库名称: $dbName");
  //然后全写进全局变量中
  GlobalData().web_api_config.WebApiUrl = webApiUrl;
  GlobalData().db_config.DbName = dbName;
}
