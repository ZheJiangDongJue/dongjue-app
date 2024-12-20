import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context, String title, String content) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // 返回 false 表示取消
            child: const Text('否'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // 返回 true 表示确认
            child: const Text('是'),
          ),
        ],
      );
    },
  );
}

//showSnackBar(在显示之前快速过掉之前的SnackBar)
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}