import 'dart:convert';

import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/module/helper/barcode_scanner_page.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;
import 'package:dongjue_application/web_api/general_entity_api.dart' as general_entity_api;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class BatchReceivePage extends StatefulWidget {
  const BatchReceivePage({super.key});

  @override
  State<BatchReceivePage> createState() => _BatchReceivePageState();
}

class _BatchReceivePageState extends State<BatchReceivePage> {
  // 添加数据列表
  List<RowItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('批量接收'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
          Visibility(
            visible: items.isEmpty,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('还没有添加待办的流程卡,试试'),
                  createAddNewRowItemButton(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 64),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        if (items.isEmpty) {
                          showSnackBar(context, '当前列表中没有数据');
                          return;
                        }
                        var list = <Map>[];
                        for (var element in items) {
                          list.add({
                            'ProcessAssemblyFlowDocumentid': element.processAssemblyFlowDocumentid,
                            'Employeeid': element.employeeid,
                            'Qty': element.qty,
                          });
                        }
                        var result = await bill_api.batchReceiptProcessAssemblyFlowDocument(list);
                        if (result['Status'] == 200) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('提示'),
                              content: const Text('批量接收成功'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      items.clear();
                                    });
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showSnackBar(context, result['Message']);
                        }
                      },
                      label: const Text('全部提交'),
                      icon: const Icon(Icons.upload)),
                  createAddNewRowItemButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton createAddNewRowItemButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('添加待办'),
      onPressed: AddNewRowItem,
    );
  }

  void AddNewRowItem() {
    var model = RowItemEditorModel();
    model.setExistItems(items);
    model.newRow();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RowItemEditorPage(
          pageTitle: '添加待办工序接收',
          model: model,
          onSubmit: (item) {
            setState(() {
              items.add(item);
            });
          },
        ),
      ),
    );
  }

  Widget createCard(int index) {
    // 注意：方法名改为小写开头符合Dart规范
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('制令单号:${items[index].innerKey}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('操作员:${items[index].employeeName}'),
            Text('数量:${items[index].qty}'),
          ],
        ),
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
          var model = RowItemEditorModel();
          model.setCurrentIndex(index);
          model.setExistItems(items);
          model.openRow(items[index]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RowItemEditorPage(
                pageTitle: '编辑工序接收',
                model: model,
                onSubmit: (item) {
                  setState(() {
                    items[index] = item;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class RowItemEditorPage extends StatefulWidget {
  final String pageTitle;
  final Function(RowItem item) onSubmit;

  final RowItemEditorModel model;

  const RowItemEditorPage({super.key, required this.pageTitle, required this.model, required this.onSubmit});

  @override
  State<RowItemEditorPage> createState() => _RowItemEditorPageState();
}

class _RowItemEditorPageState extends State<RowItemEditorPage> {
  final FocusNode _focusNodeForInnerKey = FocusNode();
  final FocusNode _focusNodeForEmployeeCodeForScan = FocusNode();
  final FocusNode _focusNodeForQty = FocusNode();
  final TextEditingController controllerInnerKey = TextEditingController(text: '');
  final TextEditingController controllerEmployeeCodeForScan = TextEditingController(text: '');
  final TextEditingController controllerQty = TextEditingController(text: '0');
  bool innerKeyChanged = false;
  bool employeeCodeForScanChanged = false;
  bool qtyChanged = false;

  @override
  void initState() {
    _focusNodeForInnerKey.addListener(() async {
      if (!_focusNodeForInnerKey.hasFocus) {
        if (innerKeyChanged) {
          innerKeyChanged = false;
          await findAndSetDailyPlanDetail(controllerInnerKey);
        }
      }
    });
    _focusNodeForEmployeeCodeForScan.addListener(() async {
      if (!_focusNodeForEmployeeCodeForScan.hasFocus) {
        if (employeeCodeForScanChanged) {
          employeeCodeForScanChanged = false;
          await findAndSetEmployee(controllerEmployeeCodeForScan);
        }
      }
    });
    _focusNodeForQty.addListener(() {
      if (!_focusNodeForQty.hasFocus) {
        if (qtyChanged) {
          qtyChanged = false;
          var v = double.tryParse(controllerQty.text);
          if (v != null) {
            widget.model.setQty(v);
          } else {
            showSnackBar(context, '数量格式不正确');
            controllerQty.text = '0';
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeForInnerKey.dispose();
    _focusNodeForEmployeeCodeForScan.dispose();
    _focusNodeForQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => widget.model),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.pageTitle),
        ),
        body: SingleChildScrollView(
          child: Consumer<RowItemEditorModel>(
            builder: (context, model, child) {
              controllerInnerKey.text = widget.model.openedItem.innerKey;
              controllerEmployeeCodeForScan.text = widget.model.openedItem.employeeCodeForScan;
              controllerQty.text = widget.model.openedItem.qty == 0 ? '0' : widget.model.openedItem.qty.toString();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: controllerInnerKey,
                      focusNode: _focusNodeForInnerKey,
                      decoration: InputDecoration(
                        labelText: '制令单号',
                        hintText: '试试扫码?',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                            );

                            if (result is Barcode && result.displayValue != null) {
                              controllerInnerKey.text = result.displayValue!;
                              findAndSetDailyPlanDetail(controllerInnerKey);
                            }
                          },
                        ),
                      ),
                      onChanged: (value) => innerKeyChanged = true,
                      onSubmitted: (s) {
                        findAndSetDailyPlanDetail(controllerInnerKey);
                      },
                    ),
                    TextField(
                      controller: controllerEmployeeCodeForScan,
                      focusNode: _focusNodeForEmployeeCodeForScan,
                      decoration: InputDecoration(
                        labelText: '操作员条码',
                        hintText: '试试扫码?',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
                            );

                            if (result is Barcode && result.displayValue != null) {
                              controllerEmployeeCodeForScan.text = result.displayValue!;
                              findAndSetEmployee(controllerEmployeeCodeForScan);
                            }
                          },
                        ),
                      ),
                      onChanged: (value) => employeeCodeForScanChanged = true,
                      onSubmitted: (s) {
                        findAndSetEmployee(controllerEmployeeCodeForScan);
                      },
                    ),
                    TextField(
                      controller: controllerQty,
                      focusNode: _focusNodeForQty,
                      decoration: const InputDecoration(labelText: '数量'),
                      onChanged: (value) => qtyChanged = true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            _focusNodeForInnerKey.unfocus();
                            _focusNodeForEmployeeCodeForScan.unfocus();
                            _focusNodeForQty.unfocus();
                            if (model.verify(context)) {
                              widget.onSubmit(model.openedItem);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('确定'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 修改成功返回true
  Future<bool> findAndSetDailyPlanDetail(TextEditingController controller) async {
    if (controller.text.isEmpty) {
      return false;
    }
    if (widget.model.Items != null) {
      var items = widget.model.Items!;
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if (item.innerKey == controller.text && widget.model.currentIndex != i) {
          showSnackBar(context, '制令单号 ${controller.text} 已经存在');
          setState(() {
            controller.text = widget.model.openedItem.innerKey;
            //   widget.model.clearQty();
            //   widget.model.clearDailyPlanDetail();
          });
          _focusNodeForInnerKey.requestFocus();
          return false;
        }
      }
    }
    var checkResult = await bill_api.checkOrCreateProcessAssemblyFlowDocument(controller.text);
    if (checkResult['Status'] != 200) {
      showSnackBar(context, checkResult['Message']);
      setState(() {
        controller.text = widget.model.openedItem.innerKey;
      });
      _focusNodeForInnerKey.requestFocus();
      return false;
    }
    var list = await general_entity_api.getDataUseField('ProcessAssemblyFlowDocument', 'InnerKey', [controller.text]);
    if (list.isNotEmpty) {
      var obj = list[0];
      // 获取制令单号对应的数量
      var pack = await bill_api.getNextReceiveProcessAssemblyFlowDetailQty(obj['id']);
      if (pack['Status'] == 200) {
        var qty = jsonDecode(pack['Data']);
        widget.model.setQty(qty);
      } else {
        showSnackBar(context, pack['Message']);
        setState(() {
          widget.model.clearQty();
          widget.model.clearDailyPlanDetail();
        });
        return false;
      }

      widget.model.setDailyPlanDetail(obj['id'], obj['InnerKey']);
      _focusNodeForEmployeeCodeForScan.requestFocus();
      return true;
    } else {
      showSnackBar(context, '没有找到制令单号 ${controller.text}');
      setState(() {
        controller.text = widget.model.openedItem.innerKey;
        //   widget.model.clearQty();
        //   widget.model.clearDailyPlanDetail();
      });
      return false;
    }
  }

  /// 修改成功返回true
  Future<void> findAndSetEmployee(TextEditingController controller) async {
    if (controller.text.isEmpty) {
      return;
    }
    var list = await general_entity_api.getDataUseField('Employee', 'CodeForScan', [controller.text]);
    if (list.isNotEmpty) {
      var obj = list[0];
      widget.model.setEmployee(obj['id'], obj['Name'], obj['CodeForScan']);
      _focusNodeForQty.requestFocus();
    } else {
      showSnackBar(context, '没有找到此操作员 ${controller.text}');
      setState(() {
        widget.model.clearEmployee();
      });
    }
  }
}

class RowItemEditorModel extends ChangeNotifier {
  late RowItem openedItem;

  List<RowItem>? Items;

  int currentIndex = -1;

  RowItem newRow() {
    openedItem = RowItem(processAssemblyFlowDocumentid: 0, innerKey: '', employeeid: 0, employeeName: '', employeeCodeForScan: '', qty: 0);
    notifyListeners();
    return openedItem;
  }

  RowItem openRow(RowItem item) {
    openedItem = item;
    notifyListeners();
    return openedItem;
  }

  RowItem setDailyPlanDetail(int id, String innerKey) {
    openedItem.processAssemblyFlowDocumentid = id;
    openedItem.innerKey = innerKey;
    notifyListeners();
    return openedItem;
  }

  RowItem clearDailyPlanDetail() {
    openedItem.processAssemblyFlowDocumentid = 0;
    openedItem.innerKey = '';
    notifyListeners();
    return openedItem;
  }

  RowItem setEmployee(int id, String name, String codeForScan) {
    openedItem.employeeid = id;
    openedItem.employeeName = name;
    openedItem.employeeCodeForScan = codeForScan;
    notifyListeners();
    return openedItem;
  }

  RowItem clearEmployee() {
    openedItem.employeeid = 0;
    openedItem.employeeName = '';
    openedItem.employeeCodeForScan = '';
    notifyListeners();
    return openedItem;
  }

  RowItem setQty(double qty) {
    openedItem.qty = qty;
    notifyListeners();
    return openedItem;
  }

  RowItem clearQty() {
    openedItem.qty = 0;
    openedItem.maxLimitQty = 0;
    notifyListeners();
    return openedItem;
  }

  bool verify(BuildContext context) {
    if (openedItem.innerKey.isEmpty) {
      showSnackBar(context, '制令单号不能为空');
      return false;
    }
    if (openedItem.employeeCodeForScan.isEmpty) {
      showSnackBar(context, '操作员不能为空');
      return false;
    }
    if (openedItem.qty == 0) {
      showSnackBar(context, '数量不能为0');
      return false;
    }
    return true;
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
  }

  void setExistItems(List<RowItem> items) {
    Items = items;
  }
}

class RowItem {
  int processAssemblyFlowDocumentid;
  String innerKey;
  int employeeid;
  String employeeName;
  String employeeCodeForScan;
  double qty;
  double maxLimitQty = 0;

  RowItem(
      {required this.processAssemblyFlowDocumentid,
      required this.innerKey,
      required this.employeeid,
      required this.employeeName,
      required this.employeeCodeForScan,
      required this.qty,
      maxLimitQty});
}
