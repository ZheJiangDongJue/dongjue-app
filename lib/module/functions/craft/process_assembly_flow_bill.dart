import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/helpers/formatter.dart';
import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/bill_detail.dart';
import 'package:dongjue_application/module/basic/bill_header.dart';
import 'package:dongjue_application/module/basic/bill_page_base.dart';
import 'package:dongjue_application/module/basic/form_page.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/controls/item_selector_button.dart';
import 'package:dongjue_application/module/functions/craft/assembly_process_completion_bill_editor_page.dart';
import 'package:dongjue_application/module/functions/craft/assembly_process_receive_bill_editor_page.dart';
import 'package:dongjue_application/module/model/loading_model.dart';
import 'package:dongjue_application/orm/craft/process_assembly_flow_detail.dart';
import 'package:dongjue_application/orm/craft/process_assembly_flow_document.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:flutter/material.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;
import 'package:collection/collection.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ProcessAssemblyFlowBill extends BillPageStatefulWidget {
  const ProcessAssemblyFlowBill({super.key});

  @override
  State<ProcessAssemblyFlowBill> createState() => _ProcessAssemblyFlowBillState();
}

class _ProcessAssemblyFlowBillState extends State<ProcessAssemblyFlowBill> {
  List? materials;

  List? typeofWorks;
  List? routingDocuments;
  List? employees;

  Map? typeofWorkDict;
  Map? employeeDict;

  Map<String, ColumnInfo>? detailColumnInfos;
  // late DataGridController _dataGridController;

  static const int qtyDecimalPlaces = 2;

  late BillModel billModel;
  late BillDetailModel billDetailModel;
  late LoadingModel loadingModel;

  @override
  void initState() {
    super.initState();

    // _dataGridController = DataGridController();
    loadingModel = LoadingModel();
    billModel = BillModel(tableName: "ProcessAssemblyFlowDocument");
    billDetailModel = BillDetailModel();
    billDetailModel.bindBillModel(billModel);
    setState(() {
      loadingModel.isDataLoading = true;
      //初始化单据
      billModel.setBillData(ProcessAssemblyFlowDocument());
    });
    billDetailModel.detailDataSourceRowAdapterBuilder = (cell) {
      if (cell.columnName == 'JieShou') {
        var value = int.tryParse(cell.value) ?? 0;
        Widget widget = const SizedBox.shrink();
        switch (value) {
          case 0:
            widget = const SizedBox.shrink();
          case 1:
            widget = Image.asset('assets/images/State_Task_Deferred.png');
          case 2:
            widget = Image.asset('assets/images/Properties_16x16.png');
          case 3:
            widget = Image.asset('assets/images/Action_Deny.png');
        }
        return Container(
          color: value == 2 ? Colors.green[300] : Colors.transparent,
          child: widget,
        );
      } else if (cell.columnName == 'WanGong') {
        var value = int.tryParse(cell.value) ?? 0;
        Widget widget = const SizedBox.shrink();
        switch (value) {
          case 0:
            widget = const SizedBox.shrink();
          case 1:
            widget = Image.asset('assets/images/State_Task_Deferred.png');
          case 2:
            widget = Image.asset('assets/images/Properties_16x16.png');
          case 3:
            widget = Image.asset('assets/images/Action_Deny.png');
        }
        return Container(
          color: value == 2 ? Colors.green[300] : Colors.transparent,
          child: widget,
        );
      }
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          cell.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    };

    billDetailModel.detailDataSourceEditWidgetBuilder = (dataGridRow, rowColumnIndex, column, submitCell) {
      if (column.columnName == 'JieShou') {
        return null;
      } else if (column.columnName == 'WanGong') {
        return null;
      }

      Alignment textAlign = Alignment.centerLeft;
      TextInputType keyBoardType = TextInputType.text;

      if (this.detailColumnInfos == null) return null;

      var detailColumnInfos = this.detailColumnInfos!;

      if (!detailColumnInfos.containsKey(column.columnName)) {
        return null;
      }

      final detailColumn = detailColumnInfos[column.columnName]!;
      if (detailColumn.readOnly == true) {
        return null;
      }
      if (detailColumn.editWidgetBuilder != null) {
        return detailColumn.editWidgetBuilder!(dataGridRow, rowColumnIndex, column, submitCell);
      }

      if (detailColumn.type == int || detailColumn.type == double) {
        textAlign = Alignment.centerRight;
        keyBoardType = TextInputType.number;
      }

      final String displayText = dataGridRow.getCells()[rowColumnIndex.columnIndex].value?.toString() ?? '';

      var editingController = TextEditingController(text: displayText);
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: textAlign,
        child: TextField(
          autofocus: true,
          controller: editingController..text = displayText,
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          keyboardType: keyBoardType,
          onChanged: (String value) {
            if (detailColumn.type == int) {
              billDetailModel.detailDataSource.newCellValue = int.tryParse(value) ?? 0;
            } else if (detailColumn.type == double) {
              billDetailModel.detailDataSource.newCellValue = double.tryParse(value) ?? 0.0;
            } else {
              billDetailModel.detailDataSource.newCellValue = value;
            }
          },
          onSubmitted: (String value) {
            submitCell();
          },
        ),
      );
    };

    var y1 = 60.0;
    var y2 = 120.0;
    billModel.onControlCreator = () {
      return [
        TextBoxInfo(
            title: '制令单号',
            controller: TextEditingController(text: billModel.data['InnerKey']),
            onChanged: (value) {
              billModel.data['InnerKey'] = value;
            },
            x: 200),
        TextBoxInfo(
            title: '计划数',
            controller: TextEditingController(text: (billModel.data['BQty'] as double).format(qtyDecimalPlaces)),
            onChanged: (value) {
              billModel.data['BQty'] = value;
            },
            x: 400),
        DateTimePickerInfo(
            title: '单据日期',
            onChanged: (value) {
              billModel.data['DocumentTime'] = value;
            },
            x: 600),
        TextBoxInfo(
            title: '单据编码',
            controller: TextEditingController(text: billModel.data['Code']),
            onChanged: (value) {
              billModel.data['Code'] = value;
            },
            x: 800),
        TextBoxInfo(title: '物料名称', readOnly: true, controller: TextEditingController(text: billModel.attachData['Material']?["Name"] ?? ""), x: 0, y: y1),
        TextBoxInfo(title: '规格型号说明', readOnly: true, controller: TextEditingController(text: billModel.attachData['Material']?["SpecTypeExplain"] ?? ""), x: 200, y: y1),
        TextBoxInfo(title: '生产数', controller: TextEditingController(text: (billModel.data['PreCmpBQty'] as double).format(qtyDecimalPlaces)), x: 400, y: y1),
        DateTimePickerInfo(
            title: '客户交期',
            value: billModel.data['DeliveryTime'],
            onChanged: (item) {
              billModel.data['DeliveryTime'] = item;
            },
            x: 600,
            y: y1),
        TextBoxInfo(title: '关联单据', readOnly: true, controller: TextEditingController(text: ''), x: 800, y: y1),
        TextBoxInfo(title: '规格型号', readOnly: true, controller: TextEditingController(text: billModel.attachData['Material']?["SpecType"] ?? ""), x: 0, y: y2),
        TextBoxInfo(title: '物料图号', readOnly: true, controller: TextEditingController(text: billModel.attachData['Material']?["TuHao"] ?? ""), x: 200, y: y2),
        TextBoxInfo(
            title: '合格数',
            controller: TextEditingController(text: (billModel.data['CmpBQty'] as double).format(qtyDecimalPlaces)),
            onChanged: (item) {
              billModel.data['CmpBQty'] = item;
            },
            x: 400,
            y: y2),
        TextBoxInfo(
            title: '备注',
            controller: TextEditingController(text: billModel.data['Note']),
            onChanged: (item) {
              billModel.data['Note'] = item;
            },
            x: 800,
            y: y2)
      ];
    };

    billDetailModel.detailColumns = <ColumnInfo>[
      ColumnInfo(
        header: "序号",
        fieldName: "index",
        type: int,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          return billDetailModel.detailsData.indexOf(e) + 1;
        },
      ),
      ColumnInfo(header: "合格数", fieldName: "CmpBQty", type: double),
      ColumnInfo(
        header: "操作工",
        fieldName: "VestInName",
        type: dynamic,
        cellValueBuilder: (e, fieldName) {
          var vestInid = e["VestInid"];
          var employeeDict = this.employeeDict ?? {};
          if (employeeDict.containsKey(vestInid)) {
            return employeeDict[vestInid]["Name"];
          }
          return '';
        },
        editWidgetBuilder: (dataGridRow, rowColumnIndex, column, submitCell) {
          return ItemSelectorButton(
            pageTitle: "选择操作工",
            text: dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString(),
            items: employees != null ? employees! : [],
            itemWidgetBuilder: (item) {
              return Text(item["Name"]);
            },
            onSelected: (item) async {
              if (item is Map) {
                billDetailModel.detailDataSource.newCellValue = item['Name'];
                var id = item['id'];
                billDetailModel.detailDataSource.details[rowColumnIndex.rowIndex]["VestInid"] = id;
              }
            },
            itemTextGetter: (item) => item?['Name'] ?? '',
          );
        },
      ),
      ColumnInfo(
        header: "工序",
        fieldName: "TypeofWorkName",
        type: dynamic,
        cellValueBuilder: (e, fieldName) {
          var typeofWorkid = e["TypeofWorkid"];
          var typeofWorkDict = this.typeofWorkDict ?? {};
          if (typeofWorkDict.containsKey(typeofWorkid)) {
            return typeofWorkDict[typeofWorkid]["Name"];
          }
          return '';
        },
        editWidgetBuilder: (dataGridRow, rowColumnIndex, column, submitCell) {
          return ItemSelectorButton(
            pageTitle: "选择工序",
            text: dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString(),
            items: typeofWorks != null ? typeofWorks! : [],
            itemWidgetBuilder: (item) {
              return Text(item["Name"]);
            },
            onSelected: (item) async {
              if (item is Map) {
                billDetailModel.detailDataSource.newCellValue = item['Name'];
              }
            },
            itemTextGetter: (item) => item?['Name'] ?? '',
          );
        },
      ),
      ColumnInfo(header: "工价", fieldName: "WorkPrice", type: double),
      ColumnInfo(header: "计划数", fieldName: "BQty", type: double),
      ColumnInfo(header: "计件工资", fieldName: "PieceRateWage", type: double),
      ColumnInfo(
        header: "工序编码",
        fieldName: "TypeofWorkCode",
        type: String,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          var typeofWorkid = e["TypeofWorkid"];
          var typeofWorkDict = this.typeofWorkDict ?? {};
          if (typeofWorkDict.containsKey(typeofWorkid)) {
            return typeofWorkDict[typeofWorkid]["Code"];
          }
          return '';
        },
      ),
      ColumnInfo(
        header: "工艺内容",
        fieldName: "TypeofWorkContent",
        type: String,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          var typeofWorkid = e["TypeofWorkid"];
          var typeofWorkDict = this.typeofWorkDict ?? {};
          if (typeofWorkDict.containsKey(typeofWorkid)) {
            return typeofWorkDict[typeofWorkid]["Content"] ?? '';
          }
          return '';
        },
      ),
      ColumnInfo(
        header: "工艺要求",
        fieldName: "TypeofWorkWorkRequirements",
        type: String,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          var typeofWorkid = e["TypeofWorkid"];
          var typeofWorkDict = this.typeofWorkDict ?? {};
          if (typeofWorkDict.containsKey(typeofWorkid)) {
            return typeofWorkDict[typeofWorkid]["WorkRequirements"] ?? '';
          }
          return '';
        },
      ),
      ColumnInfo(header: "生产数", fieldName: "PreCmpBQty", type: double),
      ColumnInfo(
        header: "接收",
        fieldName: "JieShou",
        type: int,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          return e['ReceiveStatus'];
        },
      ),
      ColumnInfo(
        header: "完工",
        fieldName: "WanGong",
        type: int,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          return e['CompleteStatus'];
        },
      ),
      ColumnInfo(
        header: "备注",
        fieldName: "Note",
        type: String,
      ),
    ];

    detailColumnInfos = {for (var item in billDetailModel.detailColumns as Iterable<ColumnInfo>) item.fieldName: item};

    billModel.onBillChanged = (bill) async {
      var list = (await bill_api.getDataUseIds("Material", [bill['Materialid']]));
      var list1 = (await bill_api.getDataUseIds("RoutingDocument", [bill['RoutingDocumentid']]));
      billModel.setAttachData('Material', list.firstOrNull);
      billModel.setAttachData('RoutingDocument', list1.firstOrNull);
      return;
    };
    billDetailModel.onDetailsChanged = (details) {
      //TODO:这里其实可以优化,当所需数据没有加载完成或者失效了,则获取所有明细涉及的id,然后去数据库中获取出来用于显示,并记载到对应的attachData中(明细目前没有attachData,之后如果需要的话可以加)
    };

    //加载所需数据
    var materialGetTask = bill_api.getDataPage("Material", 999999, 1).whenComplete(() => loadingModel.loadingMessage = "[物料]加载完毕");
    var typeofWorkGetTask = bill_api.getDataPage("TypeofWork", 999999, 1).whenComplete(() => loadingModel.loadingMessage = "[工序]加载完毕");
    var routingDocumentGetTask = bill_api.getDataPage("RoutingDocument", 999999, 1).whenComplete(() => loadingModel.loadingMessage = "[工艺路线]加载完毕");
    var employeeGetTask = bill_api.getDataPage("Employee", 999999, 1).whenComplete(() => loadingModel.loadingMessage = "[职员]加载完毕");
    Future.wait([
      materialGetTask,
      typeofWorkGetTask,
      routingDocumentGetTask,
      employeeGetTask,
    ]).then((list) {
      setState(() {
        materials = list[0];
        typeofWorks = list[1];
        routingDocuments = list[2];
        employees = list[3];

        typeofWorkDict = {for (var e in typeofWorks as Iterable) e['id']: e};
        employeeDict = {for (var e in employees as Iterable) e['id']: e};
        loadingModel.isDataLoading = false;
      });
      showSnackBar(context, "所需数据加载完成");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => loadingModel),
        ChangeNotifierProvider(create: (_) => billModel),
        ChangeNotifierProvider(create: (_) => billDetailModel),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('组装流程卡'),
          // actions: [
          //   // PopupMenuButton<String>(
          //   //   onSelected: (String result) {
          //   //     // 处理选择的菜单项
          //   //     switch (result) {
          //   //       case 'settings':
          //   //         // 跳转到设置页面
          //   //         break;
          //   //       case 'logout':
          //   //         // 执行登出操作
          //   //         break;
          //   //     }
          //   //   },
          //   //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //   //     const PopupMenuItem<String>(
          //   //       value: 'settings',
          //   //       child: Text('Settings'),
          //   //     ),
          //   //     const PopupMenuItem<String>(
          //   //       value: 'logout',
          //   //       child: Text('Logout'),
          //   //     ),
          //   //   ],
          //   // ),
          // ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  var id = billModel.data["id"] as int;
                                  bill_api.getPrevBill(billModel.tableName, id).then(
                                    (value) {
                                      if (value == null) {
                                        showSnackBar(context, "没有更多单据了");
                                        return;
                                      }
                                      billModel.setBillData(value);
                                    },
                                  );
                                },
                                child: const Text('前单')),
                            ElevatedButton(
                                onPressed: () {
                                  var id = billModel.data["id"] as int;
                                  bill_api.getNextBill(billModel.tableName, id).then(
                                    (value) {
                                      if (value == null) {
                                        showSnackBar(context, "没有更多单据了");
                                        return;
                                      }
                                      billModel.setBillData(value);
                                    },
                                  );
                                },
                                child: const Text('后单')),
                            ElevatedButton(
                                onPressed: () {
                                  billModel.setBillData(ProcessAssemblyFlowDocument());
                                  // var id = billModel.billData["id"] as int;
                                },
                                child: const Text('新增单据')),
                            ElevatedButton(
                                onPressed: () async {
                                  //判断是否是审批状态
                                  if (DocumentStatus.fromValue(billModel.data["Status"]).value.HasFlag(DocumentStatus.approved.value)) {
                                    showSnackBar(context, "审批状态不能删除");
                                    return;
                                  }
                                  bool? b = await showConfirmationDialog(context, "删除单据", "确定要删除单据吗？");
                                  if (b == true) {
                                    bill_api.generalBillDelete(billModel.tableName, billModel.data["id"] as int).then((result) {
                                      if (result['IsSuccess']) {
                                        showSnackBar(context, "删除成功");
                                        billModel.setBillData(ProcessAssemblyFlowDocument());
                                      } else {
                                        showSnackBar(context, result['ErrorMessage']);
                                      }
                                    });
                                  }
                                },
                                child: const Text('删除单据')),
                            ElevatedButton(
                                onPressed: () {
                                  saveBill(context);
                                },
                                child: const Text('保存')),
                            ElevatedButton(
                                onPressed: () {
                                  bill_api.generalBillApproval(billModel.tableName, billModel.data["id"] as int, true).then((result) async {
                                    if (!await saveBill(context)) {
                                      return;
                                    }
                                    if (result['IsSuccess']) {
                                      showSnackBar(context, "审批成功");
                                      bill_api.getDataUseIds(billModel.tableName, [billModel.data["id"] as int]).then((list) {
                                        if (list.isNotEmpty) {
                                          setState(() {
                                            billModel.setBillData(list[0]);
                                          });
                                        }
                                      });
                                    } else {
                                      showSnackBar(context, result['ErrorMessage']);
                                    }
                                  });
                                },
                                child: const Text('审批')),
                            ElevatedButton(
                                onPressed: () {
                                  bill_api.generalBillApproval(billModel.tableName, billModel.data["id"] as int, false).then((result) {
                                    if (result['IsSuccess']) {
                                      showSnackBar(context, "反审批成功");
                                      bill_api.getDataUseIds(billModel.tableName, [billModel.data["id"] as int]).then((list) {
                                        if (list.isNotEmpty) {
                                          setState(() {
                                            billModel.setBillData(list[0]);
                                          });
                                        }
                                      });
                                    } else {
                                      showSnackBar(context, result['ErrorMessage']);
                                    }
                                  });
                                },
                                child: const Text('反审批')),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Consumer<BillModel>(
                        builder: (context, billModel, child) {
                          var status = DocumentStatus.fromValue(billModel.data["Status"]);
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
                        },
                      ),
                    ),
                  ],
                ),
                AbsorbPointer(
                  absorbing: !widget.canEdit(DocumentStatus.fromValue(billModel.data["Status"])),
                  child: BillHeader(
                    width: 1400,
                    height: 180,
                    createOtherControls: [
                      ControlCreateInfo(
                        controlInfo: ControlPositionInfo(),
                        controlCreator: () {
                          var material = billModel.attachData["Material"];
                          return Flex(
                            direction: Axis.horizontal,
                            children: [
                              const Text("物料编码"),
                              Expanded(
                                child: ItemSelectorButton(
                                  pageTitle: "选择物料",
                                  text: material != null ? material!["Code"] : "",
                                  items: materials != null ? materials! : [],
                                  itemWidgetBuilder: (item) {
                                    return Column(
                                      children: [
                                        Flex(direction: Axis.horizontal, children: [
                                          const Text("编码:"),
                                          Text(item['Code']),
                                        ]),
                                        Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            const Text("规格型号说明:"),
                                            Text(item['SpecTypeExplain'] ?? ''),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                  onSelected: (item) async {
                                    if (item is Map) {
                                      billModel.data['Materialid'] = item['id'];
                                      var list = (await bill_api.getDataUseIds("Material", [item['id']]));
                                      billModel.setAttachData('Material', list.firstOrNull);
                                    }
                                  },
                                  itemTextGetter: (item) => item?['Code'] ?? '',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      ControlCreateInfo(
                        controlInfo: ControlPositionInfo(
                          x: 600,
                          y: 120,
                          width: 180,
                        ),
                        controlCreator: () {
                          var routingDocument = billModel.attachData["RoutingDocument"];
                          return Flex(
                            direction: Axis.horizontal,
                            children: [
                              const Text("工艺路线"),
                              Expanded(
                                child: ItemSelectorButton(
                                  pageTitle: "选择工艺路线",
                                  text: routingDocument != null ? routingDocument!["Name"] : "",
                                  items: routingDocuments != null ? routingDocuments! : [],
                                  itemWidgetBuilder: (item) {
                                    return Text(item["Name"]);
                                  },
                                  onSelected: (item) async {
                                    if (item is Map) {
                                      billModel.data['RoutingDocumentid'] = item['id'];
                                      var list = (await bill_api.getDataUseIds("RoutingDocument", [item['id']]));
                                      setState(() {
                                        billModel.attachData['RoutingDocument'] = list.firstOrNull;
                                      });
                                    }
                                  },
                                  itemTextGetter: (item) => item?['Name'] ?? '',
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BillDetail(
                      detailColumnInfos: detailColumnInfos!,
                      onCellDoubleTap: (billDetailModel, details) async {
                        var rowMap = billDetailModel.detailsData[details.rowColumnIndex.rowIndex - 1];
                        var cell = billDetailModel.detailDataSource.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells()[details.rowColumnIndex.columnIndex];
                        var columnInfo = detailColumnInfos![cell.columnName];
                        if (columnInfo != null) {
                          var value = int.tryParse(cell.value.toString());
                          if (value is int) {
                            if (value != ProcessStatus.notStarted.value && value != ProcessStatus.disabled.value) {
                              Map result = {};
                              if (columnInfo.header == '接收') {
                                result = await bill_api.receiveProcessAssemblyFlowDocument(rowMap["id"]);
                              } else if (columnInfo.header == '完工') {
                                result = await bill_api.completeProcessAssemblyFlowDocument(rowMap["id"]);
                              }
                              if (result["IsSuccess"] == true) {
                                if (result["Objects"] != null) {
                                  var objects = result["Objects"] as Map;
                                  if (objects.isNotEmpty) {
                                    //已有单据
                                    if (objects["OpenDocument"] != null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          if (columnInfo.header == '接收') {
                                            var page = AssemblyProcessReceiveBillEditorPage();
                                            page.preSetData = objects["OpenDocument"];
                                            return page;
                                          } else if (columnInfo.header == '完工') {
                                            var page = AssemblyProcessCompletionBillEditorPage();
                                            page.preSetData = objects["OpenDocument"];
                                            return page;
                                          }
                                          return Container();
                                        }),
                                      );
                                      billModel.refresh();
                                    } else {
                                      if (objects["TemporaryDocument"] != null) {
                                        if (objects["TemporaryDocument"] is Map) {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              if (columnInfo.header == '接收') {
                                                var page = AssemblyProcessReceiveBillEditorPage();
                                                page.preSetData = objects["TemporaryDocument"];
                                                return page;
                                              } else if (columnInfo.header == '完工') {
                                                var page = AssemblyProcessCompletionBillEditorPage();
                                                page.preSetData = objects["TemporaryDocument"];
                                                return page;
                                              }
                                              return Container();
                                            }),
                                          );
                                          billModel.refresh();
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }),
                ),
              ],
            ),
            AbsorbPointer(
              absorbing: !widget.canEdit(DocumentStatus.fromValue(billModel.data["Status"])),
              child: Consumer<LoadingModel>(
                builder: (context, value, child) {
                  return Visibility(
                    visible: loadingModel.isDataLoading,
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
                              child: Text(loadingModel.loadingMessage),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> saveBill(BuildContext context) async {
    if (billModel.data["Uid"] == null || billModel.data["Uid"] == 0) {
      billModel.data["Uid"] = await bill_api.getNewUid();
    }
    var result = await bill_api.generalBillSave(billModel.tableName, billModel.data, []);
    if (result['IsSuccess']) {
      if (result["AddItems"] != null) {
        var addItems = result["AddItems"] as List;
        if (addItems.isNotEmpty) {
          for (var item in addItems) {
            if (item["Uid"] == billModel.data["Uid"]) {
              billModel.setBillData(item);
              break;
            }
          }
        }
      }
      if (result["UpdateItems"] != null) {
        var updateItems = result["UpdateItems"] as List;
        if (updateItems.isNotEmpty) {
          for (var item in updateItems) {
            if (item["Uid"] == billModel.data["Uid"]) {
              billModel.setBillData(item);
              break;
            }
          }
        }
      }
      showSnackBar(context, "保存成功");
      return true;
    } else {
      showSnackBar(context, result['ErrorMessage']);
      return false;
    }
  }
}
