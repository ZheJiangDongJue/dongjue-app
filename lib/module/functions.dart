import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/module/functions/craft/batch_completion.dart';
import 'package:dongjue_application/module/functions/craft/batch_receive.dart';
import 'package:dongjue_application/module/functions/craft/process_assembly_flow_bill.dart';
import 'package:dongjue_application/module/helper/barcode_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FunctionsPage extends StatefulWidget {
  const FunctionsPage({super.key});

  @override
  State<FunctionsPage> createState() => _FunctionsPageState();
}

class _FunctionsPageState extends State<FunctionsPage> {
  int selectedIndex = 0;
  Module currentModule = Module.shengchan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能页面'),
      ),
      // drawer: Drawer(
      //     child: ListView(
      //   // Important: Remove any padding from the ListView.
      //   padding: EdgeInsets.zero,
      //   children: [
      //     const DrawerHeader(
      //       decoration: BoxDecoration(
      //         color: Colors.blue,
      //       ),
      //       child: Center(
      //         child: Text('模块列表'),
      //       ),
      //     ),
      //     ListTile(
      //       title: const Text('生产系统'),
      //       onTap: () {
      //         setState(() {
      //           currentModule = Module.shengchan;
      //         });
      //       },
      //     ),
      //     ListTile(
      //       title: const Text('工艺系统'),
      //       onTap: () {
      //         setState(() {
      //           currentModule = Module.gongyi;
      //         });
      //       },
      //     ),
      //   ],
      // )),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, dynamic) {
          if (didPop) {
            return;
          }

          // 弹出dialog询问是否关闭
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('提示'),
              content: const Text('确定要退出吗?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        },
        child: BodyWidget(context),
      ),
    );
  }

  Widget BodyWidget(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                  currentModule = Module.fromValue(value);
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.factory),
                  label: Text('生产系统'),
                ),
                NavigationRailDestination(
                  // icon: const Icon(Icons.engineering),
                  icon: Icon(Icons.handyman),
                  label: Text('工艺系统'),
                ),
              ],
              selectedIndex: selectedIndex,
            ),
            Positioned.fill(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.pushNamed(context, '/usercenter');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/setting');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Column(
            children: [
              // Stack(children: [
              //   //Stack是一个层叠布局,要说理解起来,从上到下的代码就是一条条的桌布,你会从上到下一条一条盖在桌子上,最后一张桌布会盖住所有的桌布,所以最后一张桌布的代码会写在最下面
              //   const TextField(
              //     decoration: InputDecoration(
              //       hintText: '请输入搜索内容',
              //       prefixIcon: Icon(Icons.search),
              //     ),
              //     // onSubmitted: (value) {
              //     //   print(value);
              //     //   //显示提示说这个功能还没完善
              //     //   ScaffoldMessenger.of(context)
              //     //       .showSnackBar(const SnackBar(content: Text('这个功能还没完善')));
              //     // },
              //   ),
              //   Positioned(
              //       right: 0,
              //       child: IconButton(
              //           onPressed: () {
              //             //显示提示说这个功能还没完善(进页面后点一点上面那个飞机就能理解了)
              //             showSnackBar(context, '这个功能还没完善');
              //           },
              //           icon: const Icon(Icons.send)))
              // ]),
              Expanded(
                //填充剩余部分
                child: Builder(
                  builder: (context) {
                    if (Modules.modules.containsKey(currentModule)) {
                      var functions = Modules.modules[currentModule]!;
                      var myItemcount = functions.length;
                      if (myItemcount == 0) {
                        return const Center(
                          child: Text("该模块没有功能"),
                        );
                      }
                      return SingleChildScrollView(
                        child: GridView.builder(
                          //网格视图生成器
                          //下面3条属性是确保网格视图能正常显示(不设置得到话会显示不出来)
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //4列,然后行列间距是10
                              crossAxisCount: getCrossAxisCount(),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                          itemCount: myItemcount,
                          itemBuilder: (context1, index) {
                            var item = functions[index];
                            return Card(
                              onPressed: () {
                                if (item.onClick != null) {
                                  item.onClick!(context1, item);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item.icon),
                                  Text(item.name),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('模块不存在'),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  
  getCrossAxisCount() {
    //通过判断屏幕宽度来决定是4列还是10列
    if (MediaQuery.of(context).size.width < 700) {
      return 4;
    }
    return 8;
  }
}

//模块枚举
enum Module {
  shengchan(0),
  gongyi(1);

  //这里我也没太理解,可以理解是一个构造函数,然后有个int类型的value属性,这个value属性是Module枚举对应的值(上面括号里的值)
  const Module(this.value);
  final int value;

  static Module fromValue(int value) {
    return Module.values.firstWhere((element) => element.value == value);
  }
}

//手搓卡片控件
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
          duration: const Duration(milliseconds: 100), // 动画时长
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isPressed ? widget.pressedBackgroundColor : widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0), // 调整圆角
            boxShadow: [
              BoxShadow(
                // color: Colors.grey.withOpacity(0.5),
                color: Colors.transparent,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, _isPressed ? widget.pressedElevation : widget.elevation),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class Modules {
  static Map<Module, List<ModuleFunction>> modules = {
    Module.shengchan: [
      // ModuleFunction(name: "组装流程卡",onClick: (function) {}),
    ],
    Module.gongyi: [
      ModuleFunction(
          name: "组装流程卡",
          icon: Icons.storage,
          onClick: (context, function) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProcessAssemblyFlowBill()),
            );
          }),
      ModuleFunction(
          name: "流程卡批量接收",
          icon: Icons.call_received,
          onClick: (context, function) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BatchReceivePage()),
            );
          }),
      ModuleFunction(
          name: "流程卡批量完工",
          icon: Icons.call_made,
          onClick: (context, function) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BatchCompletionPage()),
            );
          }),
      // ModuleFunction(
      //     name: "组装工序接收",
      //     icon: Icons.storage,
      //     onClick: (context, function) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => AssemblyProcessReceiveBillEditorPage()),
      //       );
      //     }),
      // ModuleFunction(
      //     name: "组装工序完工",
      //     icon: Icons.storage,
      //     onClick: (context, function) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => AssemblyProcessCompletionBillEditorPage()),
      //       );
      //     }),
      ModuleFunction(
          name: "前后相机扫码测试",
          icon: Icons.storage,
          onClick: (context, function) async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
            );

            if (result is Barcode && result.displayValue != null) {
              showSnackBar(context, result.displayValue!);
            }
            // Barcode code = await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
            // );
            // // print(code.displayValue);
            // if (code.displayValue != null) {
            //   showSnackBar(context, code.displayValue!);
            // }
          }),
    ],
  };
}

typedef ModuleFunctionClickCallback = void Function(BuildContext context, ModuleFunction moduleFunction);

class ModuleFunction {
  ModuleFunctionClickCallback? onClick;

  String name;
  IconData icon;

  ModuleFunction({required this.name, required this.icon, this.onClick});
}
