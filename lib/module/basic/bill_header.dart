import 'dart:convert';

import 'package:dongjue_application/module/basic/bill_detail.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ControlCreatorDelegate = Widget Function(ControlPositionInfo controlInfo, Widget Function() controlCreator);

class BillHeader extends StatefulWidget {
  BillHeader({super.key, required this.width, required this.height, this.createOtherControls});

  double width;
  double height;

  /// onCreateOtherControl: 用于创建其他控件(创建那些通用方法不支持创建的控件)
  List<ControlCreateInfo>? createOtherControls;

  @override
  State<BillHeader> createState() => _BillHeaderState();
}

class _BillHeaderState extends State<BillHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BillModel>(
      builder: (BuildContext context, value, Widget? child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: (value.onControlCreator?.call() ?? []).map<Widget>(
                    (controlPositionInfo) {
                      return Positioned(
                        left: controlPositionInfo.x,
                        top: controlPositionInfo.y,
                        width: controlPositionInfo.width ?? 180,
                        // height: 40,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: controlPositionInfo.minWidth,
                            minHeight: controlPositionInfo.minHeight,
                            maxWidth: controlPositionInfo.maxWidth,
                            maxHeight: controlPositionInfo.maxHeight,
                          ),
                          child: MyControl(
                            controlPositionInfo: controlPositionInfo,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                Stack(
                  children: widget.createOtherControls?.map(
                        (item) {
                          return Positioned(
                            left: item.controlInfo.x,
                            top: item.controlInfo.y,
                            width: item.controlInfo.width ?? 180,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: item.controlInfo.minWidth,
                                minHeight: item.controlInfo.minHeight,
                                maxWidth: item.controlInfo.maxWidth,
                                maxHeight: item.controlInfo.maxHeight,
                              ),
                              child: item.controlCreator.call(),
                            ),
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BillModel extends ChangeNotifier {
  BillModel({required this.tableName});

  String tableName;
  Map data = {};
  Map<String, dynamic> attachData = {};
  Function? onBillChanged;
  List<ControlPositionInfo> Function()? onControlCreator;
  BillDetailModel? detailModel;

  List<ControlPositionInfo>? _controlInfos;

  List<ControlPositionInfo>? get controlInfos => _controlInfos;

  set controlInfos(List<ControlPositionInfo>? value) {
    _controlInfos = value;
    notifyListeners();
  }

  void setBillData(dynamic data) async {
    attachData = {};
    if (data is Map) {
      this.data = data;
    } else {
      this.data = jsonDecode(jsonEncode(data)) as Map;
    }
    int id = this.data["id"];
    if (detailModel != null) {
      if (this.data["id"] == 0) {
        detailModel!.setDetails([]);
      } else {
        detailModel!.setDetails(await bill_api.getBillDetail(tableName, id));
      }
    }

    onBillChanged?.call(this.data);
    notifyListeners();
  }

  void refresh(){
    setBillData(data);
  }

  void setAttachData(String key, dynamic value) {
    attachData[key] = value;
    notifyListeners();
  }

  /// 加载数据到attachData中
  Future<void> loadToAttachData(String tableName, String key, int id) async {
    List list = await bill_api.getDataUseIds(tableName, [id]);
    if (list.isNotEmpty) {
      attachData[key] = list[0];
      notifyListeners();
    }
  }
}

extension BillModelExtension on BillModel {
  void bindDetailModel(BillDetailModel detailModel) {
    this.detailModel = detailModel;
  }

  T? getField<T>(String key) {
    if (data[key] == null) {
      return null;
    }
    return data[key] as T;
  }
}

class ControlCreateInfo {
  ControlCreateInfo({
    required this.controlInfo,
    required this.controlCreator,
  });

  ControlPositionInfo controlInfo;
  Widget Function() controlCreator;
}
