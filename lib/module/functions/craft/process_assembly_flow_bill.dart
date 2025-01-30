import 'package:dongjue_application/extensions/map.dart';
import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/helpers/formatter.dart';
import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/bill_detail.dart';
import 'package:dongjue_application/module/basic/bill_header.dart';
import 'package:dongjue_application/module/basic/bill_page.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/controls/item_selector_button.dart';
import 'package:dongjue_application/module/functions/craft/assembly_process_completion_bill_editor_page.dart';
import 'package:dongjue_application/module/functions/craft/assembly_process_receive_bill_editor_page.dart';
import 'package:dongjue_application/module/model/loading_model.dart';
import 'package:dongjue_application/orm/craft/process_assembly_flow_detail.dart';
import 'package:dongjue_application/orm/craft/process_assembly_flow_document.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:dongjue_application/web_api/basic/query.dart';
import 'package:flutter/material.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ProcessAssemblyFlowBill extends BillPageStatefulWidget {
  const ProcessAssemblyFlowBill({super.key});

  @override
  State<ProcessAssemblyFlowBill> createState() => _ProcessAssemblyFlowBillState();
}

class _ProcessAssemblyFlowBillState extends PageBaseState<ProcessAssemblyFlowBill> {
  BillPageModel? billPageModel;

  List? materials;

  List? typeofWorks;
  List? routingDocuments;
  List? employees;

  Map? typeofWorkDict;
  Map? employeeDict;

  Map<String, ColumnInfo>? detailColumnInfos;
  // late DataGridController _dataGridController;

  static const int qtyDecimalPlaces = 2;

  var y1 = 30.0;
  var y2 = 60.0;

  var x0 = 0.0;
  var x1 = 200.0;
  var x2 = 400.0 + 30;
  var x3 = 600.0 - 30;
  var x4 = 800.0 - 30;

  var w0 = 180.0;
  var w1 = 180.0 + 30;
  var w2 = 180.0 - 60;
  var w3 = 180.0;
  var w4 = 180.0 + 50;

  @override
  void initState() {
    super.initState();

    this.billPageModel = BillPageModel(
      billModel: BillModel(tableName: "ProcessAssemblyFlowDocument"),
      detailModel: BillDetailModel(tableName: "ProcessAssemblyFlowDetail"),
    );

    var billPageModel = this.billPageModel!;
    BillModel billModel = billPageModel.billModel;
    BillDetailModel billDetailModel = billPageModel.detailModel;
    LoadingModel loadingModel = billPageModel.loadingModel;

    //初始化单据
    loadingModel.isDataLoading = true;
    billModel.setBillData(null);

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
      return billPageModel.defaultDetailDataSourceRowAdapterBuilder(cell);
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
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            // focusedBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: Colors.black),
            // ),
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            isDense: true,
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

    billModel.onControlCreator = () {
      return getBillHeaderControlInfo(billModel);
    };

    billDetailModel.detailColumns = getDetailColumnInfo(billDetailModel);

    detailColumnInfos = {for (var item in billDetailModel.detailColumns as Iterable<ColumnInfo>) item.fieldName: item};

    billModel.onBillChanged = (bill) async {
      var list = (await bill_api.getDataUseIds("Material", [bill['Materialid']]));
      var list1 = (await bill_api.getDataUseIds("RoutingDocument", [bill['RoutingDocumentid']]));
      billModel.setAttachData('Material', list.firstOrNull);
      billModel.setAttachData('RoutingDocument', list1.firstOrNull);
      return;
    };
    // billDetailModel.onDetailsChanged = (details) {
    //   //TODO:这里其实可以优化,当所需数据没有加载完成或者失效了,则获取所有明细涉及的id,然后去数据库中获取出来用于显示,并记载到对应的attachData中(明细目前没有attachData,之后如果需要的话可以加)
    // };

    //加载所需数据
    var materialGetTask = bill_api.getDataPageWithFields("Material", 999999, 1, ["id", "Code", "SpecTypeExplain"]).whenComplete(() => loadingModel.loadingMessage = "[物料]加载完毕");
    var typeofWorkGetTask =
        bill_api.getDataPageWithFields("TypeofWork", 999999, 1, ["id", "Name", "Code", "Content", "WorkRequirements"]).whenComplete(() => loadingModel.loadingMessage = "[工序]加载完毕");
    var routingDocumentGetTask = bill_api.getDataPageWithFields("RoutingDocument", 999999, 1, ["id", "Name"]).whenComplete(() => loadingModel.loadingMessage = "[工艺路线]加载完毕");
    var employeeGetTask = bill_api.getDataPageWithFields("Employee", 999999, 1, ["id", "Name"]).whenComplete(() => loadingModel.loadingMessage = "[职员]加载完毕");
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
  void initScanCodeResultHandler() {
    super.initScanCodeResultHandler();
    addScanCodeResultHandler(
        info: ScanCodeResultHandlerInfo(
            name: '扫描日计划条码',
            fixedLength: 12,
            handler: (value) async {
              var query = Query(tableName: 'DailyPlanDetail', shortName: 'dd', selectMode: 'top 1');
              // query.addJoin(JoinType.inner, 'DailyPlanDocument', 'db', 'dd.ParentTypeid=db.id');
              query.addWhere("dd.CodeForScan='$value'");
              var list = await bill_api.GetDataEx(query);
              var obj = list.firstOrNull;
              if (obj == null) {
                showSnackBar(context, '未找到该日计划');
                return false;
              }
              if (obj is! Map) {
                showSnackBar(context, '本次获得的日计划信息不是正常的数据类型');
                return false;
              }
              //找出id
              var dailyPlanDetailid = obj.getField<int>('id');
              if (dailyPlanDetailid == null) {
                showSnackBar(context, '无法定位具体的日计划明细');
                return false;
              }
              var dailyPlanDetailIsUseBringProcess = obj.getField<bool>('IsUseBringProcess')!;
              if (!dailyPlanDetailIsUseBringProcess) {
                showSnackBar(context, '该日计划未使用[带工艺]');
                return false;
              }

              //找单据头
              query = Query(
                tableName: 'DailyPlanDocument',
                shortName: 'dd',
                selectMode: 'top 1',
              );
              query.addWhere("dd.id=${obj.getField('ParentTypeid')}");
              var list2 = await bill_api.GetDataEx(query);
              var obj2 = list2.firstOrNull;
              if (obj2 == null) {
                showSnackBar(context, '未找到该日计划对应的单据头');
                return false;
              }
              if (obj2 is! Map) {
                showSnackBar(context, '本次获得的日计划单据头不是正常的数据类型');
                return false;
              }

              var pack = await bill_api.bringProcessGenerate('DailyPlanDocument', obj2, obj);
              if (pack == null) {
                showSnackBar(context, '生成失败');
                return false;
              }
              if (!pack.getField<bool>('IsSuccess')!) {
                showSnackBar(context, '生成失败:${pack.getField<String>('ErrorMessage')}');
                return false;
              }

              //使用日计划明细id找到组装流程卡
              query = Query(
                tableName: 'ProcessAssemblyFlowDocument',
                shortName: 'pafb',
                selectMode: 'top 1',
              );
              query.addWhere("pafb.CreateByDetailid=$dailyPlanDetailid and pafb.CreateByDetailType='DailyPlanDetail'");
              await bill_api.GetDataEx(query).then((list) {
                var obj = list.firstOrNull;
                if (obj == null) {
                  showSnackBar(context, '未找到该日计划对应的组装流程卡');
                  return false;
                }
                if (obj is! Map) {
                  showSnackBar(context, '本次获得的组装流程卡不是正常的数据类型');
                  return false;
                }
                billPageModel!.billModel.setBillData(obj);
              });

              return true;
            }));
  }

  /// 获取单据头控件信息
  List<ControlPositionInfo> getBillHeaderControlInfo(BillModel billModel) {
    return [
      TextBoxInfo(
          title: '制令单号',
          readOnly: true,
          controller: TextEditingController(text: billModel.data['InnerKey']),
          onChanged: (value) {
            billModel.data['InnerKey'] = value;
          },
          width: w1,
          x: x1),
      TextBoxInfo(
          title: '计划数',
          controller: TextEditingController(text: ((billModel.getField('BQty') ?? 0.0) as double).format(qtyDecimalPlaces)),
          onChanged: (value) {
            billModel.data['BQty'] = value;
          },
          width: w2,
          x: x2),
      DateTimePickerInfo(
          title: '单据日期',
          onChanged: (value) {
            billModel.data['DocumentTime'] = value;
          },
          x: x3,
          width: w3),
      TextBoxInfo(
          title: '单据编码',
          readOnly: true,
          controller: TextEditingController(text: billModel.data['Code']),
          onChanged: (value) {
            billModel.data['Code'] = value;
          },
          x: x4,
          width: w4),
      TextBoxInfo(
        title: '物料名称',
        readOnly: true,
        controller: TextEditingController(text: billModel.attachData['Material']?["Name"] ?? ""),
        x: x0,
        y: y1,
        width: w0,
      ),
      TextBoxInfo(
        title: '规格型号说明',
        readOnly: true,
        controller: TextEditingController(text: billModel.attachData['Material']?["SpecTypeExplain"] ?? ""),
        x: x1,
        y: y1,
        width: w1,
      ),
      TextBoxInfo(
        title: '生产数',
        controller: TextEditingController(text: ((billModel.getField('PreCmpBQty') ?? 0.0) as double).format(qtyDecimalPlaces)),
        x: x2,
        y: y1,
        width: w2,
      ),
      DateTimePickerInfo(
          title: '客户交期',
          value: billModel.data['DeliveryTime'],
          onChanged: (item) {
            billModel.data['DeliveryTime'] = item;
          },
          x: x3,
          y: y1,
          width: w3),
      TextBoxInfo(
        title: '关联单据',
        readOnly: true,
        controller: TextEditingController(text: ''),
        x: x4,
        y: y1,
        width: w4,
      ),
      TextBoxInfo(
        title: '规格型号',
        readOnly: true,
        controller: TextEditingController(text: billModel.attachData['Material']?["SpecType"] ?? ""),
        x: x0,
        y: y2,
        width: w0,
      ),
      TextBoxInfo(
        title: '物料图号',
        readOnly: true,
        controller: TextEditingController(text: billModel.attachData['Material']?["TuHao"] ?? ""),
        x: x1,
        y: y2,
        width: w1,
      ),
      TextBoxInfo(
          title: '合格数',
          controller: TextEditingController(text: ((billModel.getField('CmpBQty') ?? 0.0) as double).format(qtyDecimalPlaces)),
          onChanged: (item) {
            billModel.data['CmpBQty'] = item;
          },
          x: x2,
          y: y2,
          width: w2),
      TextBoxInfo(
          title: '备注',
          controller: TextEditingController(text: billModel.data['Note']),
          onChanged: (item) {
            billModel.data['Note'] = item;
          },
          x: x4,
          y: y2,
          width: w4)
    ];
  }

  /// 获取明细列信息
  List<ColumnInfo> getDetailColumnInfo(BillDetailModel billDetailModel) {
    return <ColumnInfo>[
      ColumnInfo(
        header: "序号",
        fieldName: "index",
        type: int,
        readOnly: true,
        cellValueBuilder: (e, fieldName) {
          return billDetailModel.detailsData.indexOf(e) + 1;
        },
      ),
      // ColumnInfo(header: "合格数", fieldName: "CmpBQty", type: double),
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
      // ColumnInfo(
      //   header: "工价",
      //   fieldName: "WorkPrice",
      //   type: double,
      //   editWidgetBuilder: (dataGridRow, rowColumnIndex, column, submitCell) {
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextField(
      //         autofocus: true,
      //         controller: TextEditingController(text: (double.tryParse(dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString()) ?? 0.0).format(qtyDecimalPlaces)),
      //         textAlign: TextAlign.left,
      //         decoration: const InputDecoration(
      //           contentPadding: EdgeInsets.zero,
      //           border: InputBorder.none,
      //           isDense: true,
      //         ),
      //         onChanged: (value) {
      //           billDetailModel.detailDataSource.newCellValue = double.tryParse(value) ?? 0.0;
      //         },
      //         onSubmitted: (value) {
      //           submitCell();
      //         },
      //       ),
      //     );
      //   },
      // ),
      // ColumnInfo(
      //     header: "计划数",
      //     fieldName: "BQty",
      //     type: double,
      //     editWidgetBuilder: (dataGridRow, rowColumnIndex, column, submitCell) {
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: TextField(
      //           autofocus: true,
      //           controller: TextEditingController(text: (double.tryParse(dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString()) ?? 0.0).format(qtyDecimalPlaces)),
      //           textAlign: TextAlign.left,
      //           decoration: const InputDecoration(
      //             // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
      //             // focusedBorder: UnderlineInputBorder(
      //             //   borderSide: BorderSide(color: Colors.black),
      //             // ),
      //             contentPadding: EdgeInsets.zero,
      //             border: InputBorder.none,
      //             isDense: true,
      //           ),
      //           onChanged: (value) {
      //             billDetailModel.detailDataSource.newCellValue = double.tryParse(value) ?? 0.0;
      //           },
      //           onSubmitted: (value) {
      //             submitCell();
      //           },
      //         ),
      //       );
      //     }),
      // ColumnInfo(
      //   header: "计件工资",
      //   fieldName: "PieceRateWage",
      //   type: double,
      //   editWidgetBuilder: (dataGridRow, rowColumnIndex, column, submitCell) {
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextField(
      //         autofocus: true,
      //         controller: TextEditingController(text: (double.tryParse(dataGridRow.getCells()[rowColumnIndex.columnIndex].value.toString()) ?? 0.0).format(qtyDecimalPlaces)),
      //         textAlign: TextAlign.left,
      //         decoration: const InputDecoration(
      //           contentPadding: EdgeInsets.zero,
      //           border: InputBorder.none,
      //           isDense: true,
      //         ),
      //         onChanged: (value) {
      //           billDetailModel.detailDataSource.newCellValue = double.tryParse(value) ?? 0.0;
      //         },
      //         onSubmitted: (value) {
      //           submitCell();
      //         },
      //       ),
      //     );
      //   },
      // ),
      // ColumnInfo(
      //   header: "工序编码",
      //   fieldName: "TypeofWorkCode",
      //   type: String,
      //   readOnly: true,
      //   cellValueBuilder: (e, fieldName) {
      //     var typeofWorkid = e["TypeofWorkid"];
      //     var typeofWorkDict = this.typeofWorkDict ?? {};
      //     if (typeofWorkDict.containsKey(typeofWorkid)) {
      //       return typeofWorkDict[typeofWorkid]["Code"];
      //     }
      //     return '';
      //   },
      // ),
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
      // ColumnInfo(header: "生产数", fieldName: "PreCmpBQty", type: double),
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
  }

  @override
  Widget build(BuildContext context) {
    if (this.billPageModel == null) {
      return Container();
    }
    var billPageModel = this.billPageModel!;
    BillModel billModel = billPageModel.billModel;
    BillDetailModel billDetailModel = billPageModel.detailModel;
    LoadingModel loadingModel = billPageModel.loadingModel;
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
            Consumer<BillModel>(
              builder: (context, billModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    createToolBar(billModel, context),
                    createBillHeader(billModel),
                    createDetails(billModel, context),
                  ],
                );
              },
            ),
            Consumer<LoadingModel>(
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
            )
          ],
        ),
      ),
    );
  }

  /// 创建明细部分
  Widget createDetails(BillModel billModel, BuildContext context) {
    if (this.billPageModel == null || this.billPageModel!.loadingModel.isDataLoading) {
      return Container();
    }
    return Expanded(
      child: BillDetail(
          readOnly: !widget.canEdit(DocumentStatus.fromValue(billModel.getField("Status") ?? 0)),
          detailColumnInfos: detailColumnInfos!,
          onCellTap: (billDetailModel, details) async {
            var index = details.rowColumnIndex.rowIndex - 1;
            //判断是否超出范围
            if (index >= billDetailModel.detailsData.length) {
              return;
            }
            var rowMap = billDetailModel.detailsData[index];
            var cell = billDetailModel.detailDataSource.dataGridRows[index].getCells()[details.rowColumnIndex.columnIndex];
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
    );
  }

  /// 创建单据头部
  Widget createBillHeader(BillModel billModel) {
    if (this.billPageModel == null || this.billPageModel!.loadingModel.isDataLoading) {
      return Container();
    }
    return AbsorbPointer(
      absorbing: !widget.canEdit(
        DocumentStatus.fromValue(billModel.getField("Status") ?? 0),
      ),
      child: BillHeader(
        width: 1400,
        height: 90,
        createOtherControls: [
          ControlCreateInfo(
            controlInfo: ControlPositionInfo(),
            controlCreator: () {
              var material = billModel.attachData["Material"];
              return SizedBox(
                width: w0,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    const Text("物料编码"),
                    Expanded(
                      child: ItemSelectorButton(
                        pageTitle: "选择物料",
                        text: material != null ? material!["Code"] : "",
                        border: Border.all(color: Colors.grey),
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
                ),
              );
            },
          ),
          ControlCreateInfo(
            controlInfo: ControlPositionInfo(
              x: x3,
              y: y2,
              width: w3,
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
                      border: Border.all(color: Colors.grey),
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
    );
  }

  /// 创建工具栏
  Widget createToolBar(BillModel billModel, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                widget.CreateIconButton(
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
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('前单'),
                ),
                widget.CreateIconButton(
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
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('后单')),
                widget.CreateIconButton(
                  onPressed: () {
                    billModel.setBillData(ProcessAssemblyFlowDocument());
                    // var id = billModel.billData["id"] as int;
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('新增单据'),
                ),
                widget.CreateIconButton(
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
                  icon: const Icon(Icons.delete),
                  label: const Text('删除单据'),
                ),
                widget.CreateIconButton(
                  onPressed: () {
                    widget.saveBill(context, billModel);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('保存'),
                ),
                widget.CreateIconButton(
                  onPressed: () async {
                    await ApprovalButtonClick(billModel);
                  },
                  icon: const Icon(Icons.check_box),
                  label: const Text('审批'),
                ),
                widget.CreateIconButton(
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
                  icon: const Icon(Icons.check_box_outline_blank),
                  label: const Text('反审批'),
                ),
                // widget.CreateIconButton(
                //   onPressed: () async {
                //     await _singleDialog(true, Alignment.centerRight);
                //   },
                //   icon: const Icon(Icons.qr_code_scanner),
                //   label: const Text('扫码'),
                // ),
                // widget.CreateIconButton(
                //   onPressed: () async {
                //     var query = Query(
                //       tableName: "Material",
                //     );
                //     var codef = '4P';
                //     query.addWhere("Code like '%$codef%'");
                //     var list = await bill_api.GetDataEx(query);
                //     return;
                //   },
                //   icon: const Icon(Icons.api),
                //   label: const Text('测试Api'),
                // ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Consumer<BillModel>(
            builder: (context, billModel, child) {
              var status = DocumentStatus.fromValue(billModel.getField("Status") ?? 0);
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
    );
  }

  _singleDialog(bool keepSingle, Alignment alignment) async {
    SmartDialog.show(
      alignment: alignment,
      keepSingle: keepSingle,
      builder: (_) {
        var code1 = TextEditingController(text: '');
        var focusNode = FocusNode();
        return Container(
          width: 400,
          height: alignment == Alignment.bottomCenter || alignment == Alignment.topCenter ? 100 : double.infinity,
          color: Theme.of(context).dialogBackgroundColor,
          child: Center(
            child: ListView(
              children: [
                createLableTextField(
                  lable: const Text('内容:'),
                  textField: TextField(
                    controller: code1,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入内容',
                    ),
                    onSubmitted: (value) async {
                      await handleScanCode(value);
                      focusNode.requestFocus();
                      code1.text = '';
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget createLableTextField({required Widget lable, required TextField textField}) {
    return Row(
      children: [
        lable,
        Expanded(
          child: textField,
        ),
      ],
    );
  }

  Future<void> ApprovalButtonClick(BillModel billModel) async {
    if (!await widget.saveBill(context, billModel)) {
      return;
    }
    bill_api.generalBillApproval(billModel.tableName, billModel.data["id"] as int, true).then((result) async {
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
  }
}
