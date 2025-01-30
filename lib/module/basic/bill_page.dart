import 'package:dongjue_application/helpers/context.dart';
import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/bill_detail.dart';
import 'package:dongjue_application/module/basic/bill_header.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/module/model/loading_model.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:dongjue_application/web_api/bill_api.dart' as bill_api;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class BillPageStatefulWidget extends PageBase {
  const BillPageStatefulWidget({super.key});
}

extension BillPageStatefulWidgetExtension on BillPageStatefulWidget {
  Color getDocumentStatusColor(int state) {
    if (state.HasFlag(DocumentStatus.approved.value)) {
      return Colors.green;
    } else if (state.HasFlag(DocumentStatus.frozen.value)) {
      return Colors.blue;
    } else if (state.HasFlag(DocumentStatus.closed.value)) {
      return Colors.blue;
    } else if (state.HasFlag(DocumentStatus.inApproval.value)) {
      return Colors.orange;
    } else if (state == DocumentStatus.unapproved.value) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Future<bool> saveBill(BuildContext context, BillModel billModel) async {
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

class BillPageModel extends ChangeNotifier {
  BillPageModel({required this.billModel, required this.detailModel}) {
    loadingModel = LoadingModel();
    detailModel.bindBillModel(billModel);
  }
  final BillModel billModel;
  final BillDetailModel detailModel;
  late LoadingModel loadingModel;

  Widget defaultDetailDataSourceRowAdapterBuilder(DataGridCell<dynamic> cell) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        cell.value.toString(),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
