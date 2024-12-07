import 'package:dongjue_application/orm/basic/child_entity_base.dart';
import 'package:dongjue_application/orm/enums.dart';
import 'package:dongjue_application/orm/interfaces/interfaces.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DetailEntityBase extends ChildEntityBase
    implements
        ICanBeGenerated,
        IDetail,
        IScanCode,
        IBusinessFlow,
        IPrintRecord {
  @JsonKey(name: 'FlowUid')
  int flowUid;

  @JsonKey(name: 'FlowLayer')
  int flowLayer;

  @JsonKey(name: 'CreateByDocumentid', nullable: true)
  int? createByDocumentId;

  @JsonKey(name: 'CreateByDocumentType')
  String? createByDocumentType;

  @JsonKey(name: 'CreateByDetailid', nullable: true)
  int? createByDetailId;

  @JsonKey(name: 'CreateByDetailType')
  String? createByDetailType;

  @JsonKey(name: 'Status')
  int status;

  @JsonKey(name: 'FinishTime', nullable: true)
  DateTime? finishTime;

  @JsonKey(name: 'FinishByUserid', nullable: true)
  int? finishByUserId;

  @JsonKey(name: 'Note')
  String? note;

  @JsonKey(name: 'CodeForScan')
  String? codeForScan;

  @JsonKey(name: 'LastPrintUserid', nullable: true)
  int? lastPrintUserId;

  @JsonKey(name: 'LastPrintUserUid', nullable: true)
  int? lastPrintUserUid;

  @JsonKey(name: 'LastPrintTime', nullable: true)
  DateTime? lastPrintTime;

  @JsonKey(name: 'PrintCount')
  int printCount;

  @JsonKey(ignore: true)
  ModifyMode modifyMode = ModifyMode.undefined;

  @JsonKey(ignore: true)
  int generateById = 0; // Provide a default value

  @JsonKey(ignore: true)
  int? parentModifyId;

  @JsonKey(ignore: true)
  DateTime modifyTime = DateTime.now(); // Provide a default value

  @JsonKey(ignore: true)
  int modifyEmployeeId = 0; // Provide a default value

  DetailEntityBase({
    this.flowUid = 0,
    this.flowLayer = 0,
    this.createByDocumentId,
    this.createByDocumentType,
    this.createByDetailId,
    this.createByDetailType,
    this.finishTime,
    this.finishByUserId,
    this.note,
    this.codeForScan,
    this.lastPrintUserId,
    this.lastPrintUserUid,
    this.lastPrintTime,
    this.printCount = 0,
  }) : status = DocumentStatus.unapproved.value;
}
