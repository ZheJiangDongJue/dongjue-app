import 'package:flutter/material.dart';

class ClickableTextField extends StatelessWidget {
  final String? initialValue;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const ClickableTextField({
    super.key,
    this.initialValue,
    this.onTap,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer( // 防止键盘弹出
        child: TextFormField(
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          decoration: const InputDecoration(
            // border: OutlineInputBorder(), // 可选，添加边框
          ),
          style: TextStyle(
             color: onTap != null ? Colors.black : Colors.blue // 可选，点击时改变颜色
            // color: Colors.black,
           ),
        ),
      ),
    );
  }
}