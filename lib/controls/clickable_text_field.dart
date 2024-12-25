import 'package:flutter/material.dart';

class ClickableTextField extends StatelessWidget {
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const ClickableTextField({
    super.key,
    this.onTap,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        // 防止键盘弹出
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: const InputDecoration(
            // border: OutlineInputBorder(), // 可选，添加边框
            // contentPadding: EdgeInsets.zero, // 移除所有 padding
            contentPadding: EdgeInsets.only(left: 4, right: 4),
            // border: InputBorder.none, // 移除边框
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            isDense: true, // 减少 TextField 的高度
          ),
          style: TextStyle(color: onTap != null ? Colors.black : Colors.blue // 可选，点击时改变颜色
              // color: Colors.black,
              ),
        ),
      ),
    );
  }
}
