import 'dart:convert';

import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:dongjue_application/web_api/bill_api.dart';
import 'package:flutter/material.dart';

abstract class FormPageStatefulWidget extends PageBase {
  const FormPageStatefulWidget({super.key});
}

extension FormPageStatefulWidgetExtension on FormPageStatefulWidget {
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
}

class FormModel extends ChangeNotifier {
  FormModel({required this.tableName});

  String tableName;
  Map<String, dynamic> attachData = {};
  Map data = {};
  Function? onFormChanged;

  void setFormData(dynamic data) {
    attachData = {};
    if (data is Map) {
      this.data = data;
    } else {
      this.data = jsonDecode(jsonEncode(data)) as Map;
    }
    // int id = formData["id"];

    onFormChanged?.call(data);
    notifyListeners();
  }

  void setAttachData(String key, dynamic value) {
    attachData[key] = value;
    notifyListeners();
  }

  /// 加载数据到attachData中
  Future<void> loadToAttachData(String tableName, String key, int id) async {
    List list = await getDataUseIds(tableName, [id]);
    if (list.isNotEmpty) {
      attachData[key] = list[0];
      notifyListeners();
    }
  }
}

extension FormModelExtension on FormModel {
  T? getField<T>(String key) {
    if (data[key] == null) {
      return null;
    }
    if (data[key] is T) {
      return data[key] as T;
    }
    return null;
  }
}
