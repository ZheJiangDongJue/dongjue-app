import 'package:dongjue_application/globals/config.dart';

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  DbConfig db_config = DbConfig(); // 数据库配置

  WebApiConfig web_api_config = WebApiConfig(); // WebApi配置

  late UserInfo user_info; // 用户信息
}

class UserInfo {
  int id = 0;
  String userName = "";
  String name = "";

  UserInfo({required this.id, required this.userName, required this.name});
}
