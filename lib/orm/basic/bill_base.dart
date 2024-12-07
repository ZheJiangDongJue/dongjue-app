import 'package:dongjue_application/orm/basic/general_entity_base.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:dongjue_application/orm/interfaces/interfaces.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class BillBase extends GeneralEntityBase
    implements IBill, ICode, IBusinessFlow, IPrintRecord {
  @JsonKey(name: 'FlowUid')
  int flowUid;

  @JsonKey(name: 'FlowLayer')
  int flowLayer;

  @JsonKey(name: 'DocumentTime')
  DateTime documentTime;

  @JsonKey(name: 'Code')
  String code;

  @JsonKey(name: 'CreateByDocumentid')
  int? createByDocumentId;

  @JsonKey(name: 'CreateByDocumentType')
  String? createByDocumentType;

  @JsonKey(name: 'CreateByDetailid')
  int? createByDetailId;

  @JsonKey(name: 'CreateByDetailType')
  String? createByDetailType;

  @JsonKey(name: 'ApprovalTime')
  DateTime? approvalTime;

  @JsonKey(name: 'ApprovalByUserid')
  int? approvalByUserId;

  @JsonKey(name: 'IsApproval')
  bool isApproval;

  @JsonKey(name: 'Status')
  int status;

  @JsonKey(name: 'FinishTime')
  DateTime? finishTime;

  @JsonKey(name: 'FinishByUserid')
  int? finishByUserId;

  @JsonKey(name: 'Note')
  String? note;

  @JsonKey(name: 'LastPrintUserid')
  int? lastPrintUserId;

  @JsonKey(name: 'LastPrintUserUid')
  int? lastPrintUserUid;

  @JsonKey(name: 'LastPrintTime')
  DateTime? lastPrintTime;

  @JsonKey(name: 'PrintCount')
  int printCount;

  @JsonKey(ignore: true)
  ModifyMode modifyMode;

  @JsonKey(ignore: true)
  int generateById;

  @JsonKey(ignore: true)
  int? parentModifyId;

  @JsonKey(ignore: true)
  DateTime? modifyTime;

  @JsonKey(ignore: true)
  int modifyEmployeeId;

  BillBase({
    this.flowUid = 0,
    this.flowLayer = 0,
    this.code = '',
    this.createByDocumentId,
    this.createByDocumentType,
    this.createByDetailId,
    this.createByDetailType,
    this.approvalTime,
    this.approvalByUserId,
    this.isApproval = false,
    this.finishTime,
    this.finishByUserId,
    this.note,
    this.printCount = 0,
    this.modifyMode = ModifyMode.undefined, //Default Value Here
    this.generateById = 0,
    this.parentModifyId,
    this.modifyEmployeeId = 0,
    super.createByUserid,
    super.deletedTag,
  })  : documentTime = DateTime.now().dateOnly,
        status = DocumentStatus.unapproved.value;
}

// Optional: Add an extension to get the integer value if needed
extension ModifyModeExtension on ModifyMode {
  int get value {
    return index;
  }
}

// Optional: Add an extension to get the integer value if needed
extension DateTimeExtension on DateTime {
  //保留日期部分
  DateTime get dateOnly {
    return DateTime(year, month, day).toUtc();
  }
}
