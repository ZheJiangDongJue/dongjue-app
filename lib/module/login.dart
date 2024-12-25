import 'dart:convert';

import 'package:dongjue_application/globals/user_info.dart';
import 'package:dongjue_application/helpers/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dongjue_application/globals.dart';
import 'package:dongjue_application/web_api/login_api.dart' as login_api;
import 'package:dongjue_application/setting.dart' as m_setting;

//登录页面以及逻辑
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//创建一个登录页面的状态类(可以理解为mvvm的viewmodel)
class _LoginPageState extends State<LoginPage> {
  //这两个控件将会代替输入框，用于我们获取用户输入的用户名和密码
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 是否记住密码
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _rememberPassword = GlobalData().login_config.rememberPassword;
    _usernameController.text = GlobalData().login_config.userName;
    _passwordController.text = GlobalData().login_config.password;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalData.DEBUG_MODE) {
      _usernameController.text = "admin";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("东爵内部系统欢迎您"),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              //限制最大宽度,防止平板等设备出现输入框太宽的问题
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: SizedBox(
                //固定大小并根据容器计算宽度(其实我感觉可以和外层容器对调一下)
                width: constraints.maxWidth * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/dongjue.svg"), //显示svg
                    //帐号输入框,密码输入框
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "用户名",
                        hintText: "请输入登录名",
                      ),
                      onSubmitted: (value) {
                        submit(context);
                      },
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "密码",
                      ),
                      onSubmitted: (value) {
                        submit(context);
                      },
                    ),
                    //记住密码
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberPassword,
                          onChanged: (value) {
                            setState(() {
                              _rememberPassword = value ?? false;
                            });
                          },
                        ),
                        const Text("记住密码"),
                      ],
                    ),
                    //登录按钮
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            await submit(context);
                          },
                          child: const Text("登录")),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 提交登录请求
  Future<void> submit(BuildContext context) async {
    if (GlobalData.DEBUG_MODE) {
      GlobalData().user_info = UserInfo(
        id: 1,
        UserName: '1',
        Name: '1',
        Jobid: 1,
      );
      // get_bill_detail("SalesOrderDocument", 27904);
      // return;
      // showDateTimePickerDialog(context);
      // return;
      // 弹出底部区域
      // showHalfScreenModalBottomSheet(
      //     context,
      //     Container(
      //       color: Colors.white, // 设置背景颜色
      //       child: Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             Text('这是底部工作表的内容'),
      //             ElevatedButton(
      //               onPressed: () {
      //                 Navigator.pop(context); // 关闭底部工作表
      //               },
      //               child: Text('关闭'),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ));
      // return;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AssemblyProcessReceiveBillEditorPage()),
      // );
      // return;
      Navigator.pushNamedAndRemoveUntil(context, '/functions', (route) => false);
      return;
    }
    String username = _usernameController.text;
    String password = _passwordController.text;
    //判断用户名是否为空
    if (username.isEmpty) {
      //提示
      showSnackBar(context, "请输入用户名");
    } else {
      // 获取数据库列表
      Map dbNames = await login_api.getDbNames(username, password);
      print(dbNames);
      if (dbNames["Status"] != 200) {
        showSnackBar(context, dbNames["Message"]);
        return;
      }
      // 选择数据库
      // 数据库列表是json字符串,需要转换为list
      List dbNamesList = jsonDecode(dbNames["Data"]);

      // 弹出选择数据库的对话框
      var result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('选择账套'),
          content: SingleChildScrollView(
            child: Column(
              children: dbNamesList.map((item) {
                return TextButton(
                  onPressed: () {
                    Navigator.pop(context, item);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(item),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );

      if (result == null) {
        return;
      }
      String dbName = result;
      GlobalData().db_config.DbName = dbName;

      //尝试登录并获取状态,可以用调试工具查看map返回值
      Map map = await login_api.login(username, password);
      if (map["IsSuccess"] == true) {
        Map userInfo = map["UserInfo"];
        GlobalData().user_info = UserInfo(
          id: userInfo["id"],
          UserName: userInfo["UserName"],
          Name: userInfo["Name"],
          Jobid: userInfo["Jobid"],
        );

        // 保存设置
        await m_setting.saveSettings(
          userName: username,
          password: _rememberPassword ? password : "",
          rememberPassword: _rememberPassword,
        );

        //跳转到功能页面且关闭当前页面
        Navigator.pushNamedAndRemoveUntil(context, '/functions', (route) => false);
      } else {
        //提示登录失败相关的消息
        showSnackBar(context, map["ErrorMessage"]);
      }
    }
  }
}

/// 显示半屏模态底部工作表
void showHalfScreenModalBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true, // 重要：允许模态底部工作表根据内容调整大小
    builder: (BuildContext context) {
      return FractionallySizedBox(
        // 使用 FractionallySizedBox 控制高度
        heightFactor: 0.5, // 设置高度为屏幕高度的一半
        child: child,
      );
    },
  );
}
