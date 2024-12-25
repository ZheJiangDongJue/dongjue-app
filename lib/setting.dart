import 'package:shared_preferences/shared_preferences.dart';

import './globals.dart';

//这是一个实现了持久化的设置代码文件

//保存设置
Future<void> saveSettings({bool? notificationsEnabled, String? webApiUrl, String? userName, String? password, bool? rememberPassword}) async {
  final prefs = await SharedPreferences.getInstance();
  if (notificationsEnabled != null) {
    await prefs.setBool('notifications', notificationsEnabled); //这个是设置通知是否开启(目前没有实装任何逻辑)
  }
  if (webApiUrl != null) {
    await prefs.setString("WebApiConfig_WebApiUrl", webApiUrl); //这个是设置webApi的地址
  }
  if (userName != null) {
    await prefs.setString("LoginConfig_UserName", userName); //这个是设置用户名
  }
  if (password != null) {
    await prefs.setString("LoginConfig_Password", password); //这个是设置密码
  }
  if (rememberPassword != null) {
    await prefs.setBool("LoginConfig_RememberPassword", rememberPassword); //这个是设置是否记住密码
  }
}

//读取设置
Future<void> loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('notifications') ?? true;
  final String webApiUrl = prefs.getString("WebApiConfig_WebApiUrl") ?? 'http://192.168.3.250:7790';
  final String userName = prefs.getString("LoginConfig_UserName") ?? '';
  final String password = prefs.getString("LoginConfig_Password") ?? '';
  final bool rememberPassword = prefs.getBool("LoginConfig_RememberPassword") ?? false;
  // // 使用加载的设置
  // print('是否通知: $notificationsEnabled');
  // print("WebApiUrl: $webApiUrl");
  // print("数据库名称: $dbName");
  //然后全写进全局变量中
  GlobalData().web_api_config.WebApiUrl = webApiUrl;
  GlobalData().login_config.userName = userName;
  GlobalData().login_config.password = password;
  GlobalData().login_config.rememberPassword = rememberPassword;
}

// 清除设置
Future<void> clearSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
