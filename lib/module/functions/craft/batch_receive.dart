import 'package:flutter/material.dart';

class BatchReceivePage extends StatefulWidget {
  const BatchReceivePage({super.key});

  @override
  State<BatchReceivePage> createState() => _BatchReceivePageState();
}

class _BatchReceivePageState extends State<BatchReceivePage> {
  // 添加示例数据列表
  List<Map<String, dynamic>> items = [
    {'Billid': 1, 'InnerKey': '111111111111111', 'Employeeid': '1', 'EmployeeName': '职员 1', 'Qty': 0},
    {'Billid': 2, 'InnerKey': '222222222222222', 'Employeeid': '2', 'EmployeeName': '职员 2', 'Qty': 0},
    {'Billid': 3, 'InnerKey': '333333333333333', 'Employeeid': '3', 'EmployeeName': '职员 3', 'Qty': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('批量接收界面测试'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // 显示添加弹窗
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('添加物品'),
                      content: const SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: '标题'),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: '描述'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 这里可以添加保存数据的逻辑
                            setState(() {
                              items.add({
                                'Billid': items.length + 1,
                                'InnerKey': '',
                                'Employeeid': '0',
                                'EmployeeName': '',
                              });
                            });
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('添加'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length, // 设置列表长度
              itemBuilder: (context, index) {
                return createCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget createCard(int index) {
    // 注意：方法名改为小写开头符合Dart规范
    var controller1 = TextEditingController(text: items[index]['InnerKey']);
    var controller2 = TextEditingController(text: items[index]['EmployeeName']);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(items[index]['InnerKey']),
        subtitle: Text(items[index]['EmployeeName']),
        trailing: const Icon(Icons.arrow_forward_ios),
        onLongPress: () {
          // 弹窗确认删除
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('删除该行'),
              content: const Text('确定要删除该行吗?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 这里可以添加删除数据的逻辑
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        },
        onTap: () {
          // 显示编辑弹窗
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('编辑 ${items[index]['InnerKey']}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: '标题'),
                      controller: controller1,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '描述'),
                      controller: controller2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 这里可以添加保存数据的逻辑
                    setState(() {
                      items[index]['InnerKey'] = controller1.text;
                      items[index]['EmployeeName'] = controller2.text;
                    });
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
