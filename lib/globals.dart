import 'package:dongjue_application/globals/config.dart';
import 'package:dongjue_application/globals/login_config.dart';
import 'package:dongjue_application/globals/user_info.dart';

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  //上面不用管,是实现单例模式的代码,主要是下面的代码

  static const bool DEBUG_MODE = false;

  //数据库配置
  DbConfig db_config = DbConfig();

  // WebApi配置
  WebApiConfig web_api_config = WebApiConfig();

  LoginConfig login_config = LoginConfig();

  // 用户信息(登录的时候会写入这里,加late会让他允许不在初始化的时候给值,直到使用之前有赋值就行,不赋值就调用会报错的.其他地方有用late修饰的属性也是这个意思)
  late UserInfo user_info; // 用户信息
}
