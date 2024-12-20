import 'package:dongjue_application/helpers/int.dart';
import 'package:dongjue_application/module/basic/page_base.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:flutter/material.dart';

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
}
