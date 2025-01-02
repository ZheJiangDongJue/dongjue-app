import 'package:dongjue_application/controls/clickable_text_field.dart';
import 'package:dongjue_application/controls/item_selector_button.dart';
import 'package:dongjue_application/extensions/date_time.dart';
import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/form_page.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/module/model/loading_model.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;

class AssemblyProcessCompletionBillEditorPage extends FormPageStatefulWidget {
  AssemblyProcessCompletionBillEditorPage({super.key});

  Map? preSetData;

  @override
  State<AssemblyProcessCompletionBillEditorPage> createState() => _AssemblyProcessCompletionBillEditorPageState();
}

class _AssemblyProcessCompletionBillEditorPageState extends State<AssemblyProcessCompletionBillEditorPage> {
  late FormModel formModel;
  late LoadingModel loadingModel;

  List? employees;
  Map? employeeDict;

  @override
  void initState() {
    super.initState();
    formModel = FormModel(tableName: "AssemblyProcessCompletionDocument");
    loadingModel = LoadingModel();
    loadingModel.isDataLoading = true;

    formModel.onFormChanged = (form) async {
      await formModel.loadToAttachData("Employee", "Employee", formModel.getField<int>("Employeeid") ?? 0);
      await formModel.loadToAttachData("Material", "Material", formModel.getField<int>("Materialid") ?? 0);
      await formModel.loadToAttachData("Warehouse", "Warehouse", formModel.getField<int>("Warehouseid") ?? 0);
      await formModel.loadToAttachData("TypeofWork", "TypeofWork", formModel.getField<int>("TypeofWorkid") ?? 0);
    };

    //加载所需数据
    var employeeGetTask = bill_api.getDataPage("Employee", 999999, 1).whenComplete(() => loadingModel.loadingMessage = "[职员]加载完毕");
    Future.wait([
      employeeGetTask,
    ]).then((list) {
      setState(() {
        employees = list[0];

        employeeDict = {for (var e in employees as Iterable) e['id']: e};
        loadingModel.isDataLoading = false;
      });
      showSnackBar(context, "所需数据加载完成");

      if (widget.preSetData != null) {
        formModel.setFormData(widget.preSetData!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => loadingModel),
        ChangeNotifierProvider(create: (context) => formModel),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('组装工序完工单'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            widget.CreateIconButton(
                                onPressed: () {
                                  var id = formModel.getField<int>("id") ?? 0;
                                  bill_api.getPrevBill(formModel.tableName, id).then(
                                    (value) {
                                      if (value == null) {
                                        showSnackBar(context, "没有更多单据了");
                                        return;
                                      }
                                      formModel.setFormData(value);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('前单')),
                            widget.CreateIconButton(
                                onPressed: () {
                                  var id = formModel.getField<int>("id") ?? 0;
                                  bill_api.getNextBill(formModel.tableName, id).then(
                                    (value) {
                                      if (value == null) {
                                        showSnackBar(context, "没有更多单据了");
                                        return;
                                      }
                                      formModel.setFormData(value);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('后单')),
                            widget.CreateIconButton(
                                onPressed: () {
                                  formModel.setFormData({});
                                  // var id = formModel.formData["id"] as int;
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('新增单据')),
                            widget.CreateIconButton(
                                onPressed: () async {
                                  //判断是否是审批状态
                                  if (DocumentStatus.fromValue(formModel.data["Status"]).value.HasFlag(DocumentStatus.approved.value)) {
                                    showSnackBar(context, "审批状态不能删除");
                                    return;
                                  }
                                  bool? b = await showConfirmationDialog(context, "删除单据", "确定要删除单据吗？");
                                  if (b == true) {
                                    bill_api.generalBillDelete(formModel.tableName, formModel.getField<int>("id") ?? 0).then((result) {
                                      if (result['IsSuccess']) {
                                        showSnackBar(context, "删除成功");
                                        formModel.setFormData({});
                                      } else {
                                        showSnackBar(context, result['ErrorMessage']);
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('删除单据')),
                            widget.CreateIconButton(
                                onPressed: () async {
                                  bool b = await saveBill(context);
                                  if (b) {
                                    showSnackBar(context, "保存成功");
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('保存')),
                            widget.CreateIconButton(
                                onPressed: () async {
                                  if (!await saveBill(context)) {
                                    return;
                                  }
                                  var billid = formModel.getField<int>("id") ?? 0;
                                  bill_api.generalBillApproval(formModel.tableName, billid, true).then((result) async {
                                    if (result['IsSuccess']) {
                                      showSnackBar(context, "审批成功");
                                      bill_api.getDataUseIds(formModel.tableName, [billid]).then((list) {
                                        if (list.isNotEmpty) {
                                          formModel.setFormData(list[0]);
                                        }
                                      });
                                    } else {
                                      showSnackBar(context, result['ErrorMessage']);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.approval),
                                label: const Text('审批')),
                            widget.CreateIconButton(
                                onPressed: () {
                                  var billid = formModel.getField<int>("id") ?? 0;
                                  bill_api.generalBillApproval(formModel.tableName, billid, false).then((result) {
                                    if (result['IsSuccess']) {
                                      showSnackBar(context, "反审批成功");
                                      bill_api.getDataUseIds(formModel.tableName, [billid]).then((list) {
                                        if (list.isNotEmpty) {
                                          setState(() {
                                            formModel.setFormData(list[0]);
                                          });
                                        }
                                      });
                                    } else {
                                      showSnackBar(context, result['ErrorMessage']);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.approval),
                                label: const Text('反审批')),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Consumer<FormModel>(builder: (context, formModel, child) {
                        var status = DocumentStatus.fromValue(formModel.data["Status"] ?? 0);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: widget.getDocumentStatusColor(status.value), width: 3.0),
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 2.0),
                            child: Text(
                              status.name,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: widget.getDocumentStatusColor(status.value),
                                fontFamily: 'SanJiXingKaiJianTi',
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<FormModel>(
                    builder: (BuildContext context, FormModel value, Widget? child) {
                      var status = DocumentStatus.fromValue(formModel.getField<int>("Status") ?? 0);
                      return SingleChildScrollView(
                        child: AbsorbPointer(
                          absorbing: !widget.canEdit(status),
                          child: Column(
                            children: [
                              widget.CreatePadding(TextFormField(
                                key: const Key('InnerKey'),
                                readOnly: true,
                                controller: TextEditingController(text: formModel.getField<String>('InnerKey') ?? ''),
                                decoration: const InputDecoration(
                                  labelText: "制令单号",
                                ),
                              )),
                              widget.CreatePadding(FormField<DateTime>(
                                key: const Key('DocumentTime'),
                                builder: (FormFieldState<DateTime> field) {
                                  var dateTime = formModel.getField<DateTime>('DocumentTime') ?? DateTime.tryParse(formModel.getField<String>('DocumentTime') ?? '');
                                  var controller = TextEditingController(text: dateTime?.formatDate());
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      label: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '接收日期',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: ClickableTextField.noneBorder(
                                      controller: controller,
                                      onTap: () async {
                                        var result = await showDateTimePickerDialog(context);
                                        if (result != null) {
                                          // field.didChange(result);
                                          formModel.data['DocumentTime'] = result;
                                          controller.text = result.formatDate();
                                          formModel.notifyListeners();
                                        }
                                      },
                                    ),
                                  );
                                },
                              )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('Code'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.getField<String>('Code') ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "单据编号",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('ClientName'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Client']?['Name'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "客户名称",
                              //   ),
                              // )),
                              widget.CreatePadding(TextFormField(
                                key: const Key('MaterialName'),
                                readOnly: true,
                                controller: TextEditingController(text: formModel.attachData['Material']?['Code'] ?? ''),
                                decoration: const InputDecoration(
                                  labelText: "物料",
                                ),
                              )),
                              widget.CreatePadding(FormField<int>(
                                builder: (FormFieldState<int> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      label: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(text: "计件人员", style: TextStyle(color: Colors.black)),
                                            TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: ItemSelectorButton(
                                      text: formModel.attachData['Employee'] != null ? formModel.attachData['Employee']!["Name"] : "",
                                      items: employees ?? [],
                                      itemWidgetBuilder: (item) {
                                        return Text(item['Name']);
                                      },
                                      onSelected: (item) async {
                                        if (item is Map) {
                                          formModel.data["Employeeid"] = item['id'];
                                          await formModel.loadToAttachData("Employee", "Employee", item['id']);
                                        }
                                      },
                                      itemTextGetter: (item) {
                                        return item?["Code"] ?? "";
                                      },
                                    ),
                                  );
                                },
                              )),
                              widget.CreatePadding(TextFormField(
                                controller: TextEditingController(text: formModel.getField<double>('PassBQty')?.toString() ?? ""),
                                decoration: InputDecoration(
                                    label: RichText(
                                  text: const TextSpan(children: [
                                    TextSpan(text: "接收数量", style: TextStyle(color: Colors.black)),
                                    TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                                  ]),
                                )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '请输入接收数量';
                                  }
                                  return null;
                                },
                              )),
                              widget.CreatePadding(TextFormField(
                                key: const Key('TypeofWorkName'),
                                readOnly: true,
                                controller: TextEditingController(text: formModel.attachData['TypeofWork']?['Name'] ?? ''),
                                decoration: const InputDecoration(
                                  labelText: "当前工序",
                                ),
                              )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('WarehouseName'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Warehouse']?['Name'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "当前车间",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('SpecTypeExplain'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Material']?['SpecTypeExplain'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "规格/颜色",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('GongXuMingCheng'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Material']?['GongXuMingCheng'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "规格/工艺",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('TuHao'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Material']?['TuHao'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "图号",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('JiShuBianMa'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Material']?['JiShuBianMa'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "技术编码",
                              //   ),
                              // )),
                              // widget.CreatePadding(TextFormField(
                              //   key: const Key('ClientMaterialCode'),
                              //   readOnly: true,
                              //   controller: TextEditingController(text: formModel.attachData['Material']?['ClientMaterialCode'] ?? ''),
                              //   decoration: const InputDecoration(
                              //     labelText: "客户物料号",
                              //   ),
                              // )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Consumer<LoadingModel>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.isDataLoading,
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SpinKitCubeGrid(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value.loadingMessage),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> saveBill(BuildContext context) async {
    if (formModel.data["Uid"] == null || formModel.data["Uid"] == 0) {
      formModel.data["Uid"] = await bill_api.getNewUid();
    }
    var result = await bill_api.generalBillSave(formModel.tableName, formModel.data, []);
    if (result['IsSuccess']) {
      if (result["AddItems"] != null) {
        var addItems = result["AddItems"] as List;
        if (addItems.isNotEmpty) {
          for (var item in addItems) {
            if (item["Uid"] == formModel.data["Uid"]) {
              formModel.setFormData(item);
              break;
            }
          }
        }
      }
      if (result["UpdateItems"] != null) {
        var updateItems = result["UpdateItems"] as List;
        if (updateItems.isNotEmpty) {
          for (var item in updateItems) {
            if (item["Uid"] == formModel.data["Uid"]) {
              formModel.setFormData(item);
              break;
            }
          }
        }
      }
      return true;
    } else {
      showSnackBar(context, result['ErrorMessage']);
      return false;
    }
  }
}
