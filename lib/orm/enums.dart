

enum DocumentStatus {
  /// 未审批
  unapproved(0),

  /// 已审批
  approved(1),

  /// 已冻结
  frozen(2),

  /// 已结案
  closed(4),

  /// 已作废
  invalid(8),

  /// 审批中
  inApproval(16),

  /// 已中止
  suspended(32),

  /// 被驳回
  rejected(64),

  /// 已确认
  confirmed(128),

  /// 变更中 (已审变更中)
  changing(256);

  const DocumentStatus(this.value);
  final int value;
}

enum ModifyMode {
  undefined,
  add,
  modify,
  delete,
}