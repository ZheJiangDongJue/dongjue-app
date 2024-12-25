import 'package:flutter/material.dart';

class TextButtonLike extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const TextButtonLike({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  _TextButtonLikeState createState() => _TextButtonLikeState();
}

class _TextButtonLikeState extends State<TextButtonLike> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed(); // 在抬起时触发回调
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.circular(4),
        //   color: _isPressed ? Colors.grey[200] : Colors.transparent, // 按下时改变背景颜色
        // ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
          color: _isPressed ? Colors.transparent : Colors.transparent, // 按下时改变背景颜色
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isPressed ? Colors.blue[700] : Colors.black, // 按下时改变文字颜色
          ),
        ),
      ),
    );
  }
}