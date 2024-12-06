import 'package:shared_preferences/shared_preferences.dart';

import './globals.dart';

Future<void> saveSettings(
    bool notificationsEnabled, String webApiUrl, String dbName) async {
  final prefs = await SharedPreferences.getInstance();
  // await prefs.setString('theme', theme);
  // await prefs.setBool('notifications', notificationsEnabled);
  await prefs.setString("WebApiConfig_WebApiUrl", webApiUrl);
  await prefs.setString("DbConfig_DbName", dbName);
}

Future<void> loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  // final theme = prefs.getString('theme') ?? 'light';
  final notificationsEnabled = prefs.getBool('notifications') ?? true;
  final String webApiUrl =
      prefs.getString("WebApiConfig_WebApiUrl") ?? '192.168.3.250:7790';
  final String dbName = prefs.getString("DbConfig_DbName") ?? 'PEM6';
  // // 使用加载的设置
  // print('主题: $theme');
  print('通知: $notificationsEnabled');
  print("WebApiUrl: $webApiUrl");
  print("DbName: $dbName");
  GlobalData().web_api_config.WebApiUrl = webApiUrl;
  GlobalData().db_config.DbName = dbName;
}
