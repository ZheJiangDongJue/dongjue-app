import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dongjue_application/module/basic/bill_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BillDetail extends StatefulWidget {
  BillDetail({super.key, required this.detailColumnInfos, this.onCellTap, this.onCellDoubleTap});

  Map<String, ColumnInfo> detailColumnInfos;

  Function(BillDetailModel billDetailModel, DataGridCellTapDetails details)? onCellTap;
  Function(BillDetailModel billDetailModel, DataGridCellDoubleTapDetails details)? onCellDoubleTap;

  @override
  State<BillDetail> createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BillDetailModel>(
      builder: (BuildContext context, value, Widget? child) {
        return SfDataGrid(
          source: value.detailDataSource,
          allowEditing: true,
          navigationMode: GridNavigationMode.cell,
          selectionMode: SelectionMode.single,
          editingGestureType: EditingGestureType.tap,
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          // controller: _dataGridController,
          columns: detailColumnHeaderBuilder(context),
          onCellTap: (details) {
            widget.onCellTap?.call(value, details);
            //   // var cell = _employeeDataSource.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells()[details.rowColumnIndex.columnIndex];
            //   // var value = cell.value;
            //   // print(value);
          },
          onCellDoubleTap: (details) {
            widget.onCellDoubleTap?.call(value, details);
          },
        );
      },
    );
  }

  /// 明细列标题构建器
  List<GridColumn> detailColumnHeaderBuilder(BuildContext context) {
    return context.watch<BillDetailModel>().detailColumns.map((item) {
      return GridColumn(
        columnName: item.fieldName,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            item.header,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }
}

class BillDetailModel extends ChangeNotifier {
  List<ColumnInfo> detailColumns = [];
  List<Map> detailsData = [];
  late DetailDataSource detailDataSource;

  Function? onDetailsChanged;

  Widget Function(DataGridCell<dynamic>)? detailDataSourceRowAdapterBuilder;
  Widget? Function(DataGridRow, RowColumnIndex, GridColumn, void Function())? detailDataSourceEditWidgetBuilder;

  void setDetails(List<dynamic> data) {
    detailsData = [];
    for (var element in data) {
      if (element is Map) {
        detailsData.add(element);
      } else {
        detailsData.add(jsonDecode(jsonEncode(element)) as Map);
      }
    }

    detailDataSource = DetailDataSource(
      builder: detailRowBuilder,
      details: detailsData,
      rowAdapterBuilder: detailDataSourceRowAdapterBuilder,
      editWidgetBuilder: detailDataSourceEditWidgetBuilder,
    );

    onDetailsChanged?.call(detailsData);
    notifyListeners();
  }

  /// 默认获取单元格值方法
  dynamic defaultGetCellValue(dynamic e, String fieldName) {
    return e[fieldName]?.toString() ?? '';
  }

  DataGridRow detailRowBuilder(e) {
    var columns = detailColumns;
    var list = columns.map((columnInfo) {
      return DataGridCell<String>(
          columnName: columnInfo.fieldName,
          value:
              columnInfo.cellValueBuilder == null ? defaultGetCellValue(e, columnInfo.fieldName) : (columnInfo.cellValueBuilder!.call(e, columnInfo.fieldName)?.toString() ?? ''));
    }).toList();
    return DataGridRow(
      cells: list,
    );
  }
}

extension BillDetailModelExtension on BillDetailModel {
  void bindBillModel(BillModel billModel) {
    billModel.bindDetailModel(this);
  }
}

class ColumnInfo {
  String header;
  String fieldName;
  Type type;

  /// 列编辑器构建器
  EditWidgetBuilderDelegate? editWidgetBuilder;

  /// 单元格内容构建器
  CellValueBuilderDelegate? cellValueBuilder;

  bool readOnly;

  ColumnInfo({required this.header, required this.fieldName, required this.type, this.readOnly = false, this.cellValueBuilder, this.editWidgetBuilder});
}

typedef CellValueBuilderDelegate = dynamic Function(dynamic e, String fieldName);
typedef RowAdapterBuilderDelegate = Widget Function(DataGridCell row);
typedef EditWidgetBuilderDelegate = Widget? Function(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell);
typedef CellSubmitDelegate = Future<void> Function(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column);

class DetailDataSource extends DataGridSource {
  DetailDataSource({required DataGridRow Function(Map e) builder, required this.details, this.cellValueGetter, this.rowAdapterBuilder, this.editWidgetBuilder, this.cellSubmit}) {
    dataGridRows = details.map<DataGridRow>(builder).toList();
  }

  RowAdapterBuilderDelegate? rowAdapterBuilder;
  EditWidgetBuilderDelegate? editWidgetBuilder;
  CellValueBuilderDelegate? cellValueGetter;
  CellSubmitDelegate? cellSubmit;

  List<DataGridRow> dataGridRows = [];

  dynamic newCellValue;

  List<Map> details;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>(rowAdapterBuilder ?? defaultRowAdapterBuilder).toList());
  }

  Widget defaultRowAdapterBuilder(dataGridCell) {
    return Container(
        alignment: (dataGridCell.columnName == 'id' || dataGridCell.columnName == 'salary') ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
        ));
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';
    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (cellSubmit != null) {
      await cellSubmit?.call(dataGridRow, rowColumnIndex, column);
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: column.columnName, value: newCellValue.toString());
      var detail = details[dataRowIndex];
      if (detail.containsKey(column.columnName)) {
        detail[column.columnName] = newCellValue;
      }
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    newCellValue = null;
    if (editWidgetBuilder != null) {
      return editWidgetBuilder?.call(dataGridRow, rowColumnIndex, column, submitCell);
    }
    return super.buildEditWidget(dataGridRow, rowColumnIndex, column, submitCell);
  }
}
