enum DocumentStatus {
  /// 未审批
  unapproved(0, "未审批"),

  /// 已审批
  approved(1, "已审批"),

  /// 已冻结
  frozen(2, "已冻结"),

  /// 已结案
  closed(4, "已结案"),

  /// 已作废
  invalid(8, "已作废"),

  /// 审批中
  inApproval(16, "审批中"),

  /// 已中止
  suspended(32, "已中止"),

  /// 被驳回
  rejected(64, "被驳回"),

  /// 已确认
  confirmed(128, "已确认"),

  /// 变更中 (已审变更中)
  changing(256, "变更中"),
  ;

  const DocumentStatus(this.value, this.name);
  final int value;
  final String name;

  static DocumentStatus fromValue(int value) {
    return DocumentStatus.values.firstWhere((element) => element.value == value,orElse: ()=>DocumentStatus.unapproved);
  }
}

enum ModifyMode {
  undefined,
  add,
  modify,
  delete,
}

// Optional: Add an extension to get the integer value if needed
extension ModifyModeExtension on ModifyMode {
  int get value {
    return index;
  }
}