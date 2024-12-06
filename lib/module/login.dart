import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../globals.dart';
import '../web_api/login_api.dart' as login_api;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<dynamic> futureAlbum;

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
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: SizedBox(
                width: constraints.maxWidth * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/dongjue.svg"),
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
                            //判断是否为空
                            if (username.isEmpty) {
                              //提示
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("请输入用户名")));
                            } else {
                              //判断用户名和密码是否正确
                              // futureAlbum = login_api.login(username, password);
                              Map map = await login_api.login(username, password);
                              if (map["IsSuccess"] == true) {
                                Map userInfo = map["UserInfo"];
                                GlobalData().user_info = UserInfo(id: userInfo["id"], userName: userInfo["UserName"], name: userInfo["Name"]);
                                //跳转到功能页面且关闭当前页面
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/functions', (route) => false);
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(map["ErrorMessage"])));
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
