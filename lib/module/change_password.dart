import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/web_api/login_api.dart';
import 'package:dongjue_application/web_api/other_api.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改密码'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(labelText: '旧密码'),
            obscureText: true,
          ),
          TextField(
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: '新密码'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: '确认密码'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              // 检查旧密码是否正确
              bool b = await checkPassword(_oldPasswordController.text);
              if (b == false) {
                showSnackBar(context, '旧密码错误');
                return;
              }

              // 校验两次输入的密码是否一致
              String newPassword = _newPasswordController.text;
              String confirmPassword = _confirmPasswordController.text;
              if (newPassword != confirmPassword) {
                showSnackBar(context, '两次输入的密码不一致');
                return;
              }

              // 修改密码
              Map map = await changePassword(_oldPasswordController.text, _oldPasswordController.text, _newPasswordController.text);
              if (map['IsSuccess'] == true) {
                showSnackBar(context, '修改密码成功');
              } else {
                //对话框
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('修改密码失败'),
                    content: Text(map['ErrorMessage']),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('修改'),
          ),
        ],
      ),
    );
  }
}
