import 'package:flutter/material.dart';

class FunctionsPage extends StatefulWidget {
  const FunctionsPage({super.key});

  @override
  State<FunctionsPage> createState() => _FunctionsPageState();
}

class _FunctionsPageState extends State<FunctionsPage> {
  Module currentModule = Module.shengchan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('功能页面'),
        ),
        drawer: Drawer(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text('模块列表'),
              ),
            ),
            ListTile(
              title: const Text('生产系统'),
              onTap: () {
                setState(() {
                  currentModule = Module.shengchan;
                });
              },
            ),
            ListTile(
              title: const Text('工艺系统'),
              onTap: () {
                setState(() {
                  currentModule = Module.gongyi;
                });
              },
            ),
          ],
        )),
        body: Column(children: [
          Stack(children: [
            const TextField(
              decoration: InputDecoration(
                hintText: '请输入搜索内容',
                prefixIcon: Icon(Icons.search),
              ),
              // onSubmitted: (value) {
              //   print(value);
              //   //显示提示说这个功能还没完善
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(const SnackBar(content: Text('这个功能还没完善')));
              // },
            ),
            Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () {
                      //显示提示说这个功能还没完善
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('这个功能还没完善')));
                    },
                    icon: const Icon(Icons.send)))
          ]),
          Expanded(
              child: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: 20,
              itemBuilder: (context, index) {
                switch (currentModule) {
                  case Module.shengchan:
                    return Card(
                      onPressed: () {
                        print("点击了功能${index + 1}");
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.ac_unit),
                            Text('生产功能${index + 1}'),
                          ]),
                    );
                    break;
                  case Module.gongyi:
                    return Card(
                      onPressed: () {
                        print("点击了功能${index + 1}");
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.ac_unit),
                            Text('工艺功能${index + 1}'),
                          ]),
                    );
                    break;
                  default:
                }
              },
            ),
          ))
        ]));
  }
}

enum Module {
  shengchan(0),
  gongyi(1);

  const Module(this.value);
  final int value;
}

class Card extends StatefulWidget {
  const Card({
    super.key,
    required this.child,
    required this.onPressed,
    this.elevation = 0.0,
    this.pressedElevation = 0.0, // 默认按下时没有阴影，实现“按下”效果
    this.backgroundColor = Colors.transparent,
    this.pressedBackgroundColor = Colors.blueAccent,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final VoidCallback onPressed;
  final double elevation; // 按钮未按下时的阴影高度
  final double pressedElevation; // 按钮按下时的阴影高度
  final Color backgroundColor;
  final Color pressedBackgroundColor;
  final EdgeInsets padding;

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          widget.onPressed(); // 在手指抬起时触发onPressed回调
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100), // 动画时长，可根据需要调整
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isPressed
                ? widget.pressedBackgroundColor
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0), // 可根据需要调整圆角
            boxShadow: [
              BoxShadow(
                // color: Colors.grey.withOpacity(0.5),
                color: Colors.transparent,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(
                    0, _isPressed ? widget.pressedElevation : widget.elevation),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
