import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../globals.dart';
import '../web_api/login_api.dart' as login_api;

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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "密码",
                      ),
                    ),
                    //登录按钮
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            //判断用户名是否为空
                            if (username.isEmpty) {
                              //提示
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("请输入用户名")));
                            } else {
                              //尝试登录并获取状态,可以用调试工具查看map返回值
                              Map map =
                                  await login_api.login(username, password);
                              if (map["IsSuccess"] == true) {
                                Map userInfo = map["UserInfo"];
                                GlobalData().user_info = UserInfo(
                                    id: userInfo["id"],
                                    userName: userInfo["UserName"],
                                    name: userInfo["Name"]);
                                //跳转到功能页面且关闭当前页面
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/functions', (route) => false);
                              } else {
                                //提示登录失败相关的消息
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(map["ErrorMessage"])));
                              }
                            }
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
}
