import 'package:dongjue_application/orm/basic/detail_entity_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'process_assembly_flow_detail.g.dart';

/// <summary>
/// 组装流程卡明细数据库实体
/// </summary>
@JsonSerializable()
class ProcessAssemblyFlowDetail extends DetailEntityBase {
  /// 子位置
  @JsonKey(name: 'SubPosition')
  int subPosition;

  /// 工种id
  @JsonKey(name: 'TypeofWorkid')
  int typeofWorkid;

  /// 操作工
  @JsonKey(name: 'VestInid')
  int vestInid;

  /// 计划数
  @JsonKey(name: 'BQty')
  double bQty;

  /// 生产数
  @JsonKey(name: 'PreCmpBQty')
  double preCmpBQty;

  /// 数量
  @JsonKey(name: 'BadBQty')
  double badBQty;

  /// 合格数
  @JsonKey(name: 'CmpBQty')
  double cmpBQty;

  /// 工价
  @JsonKey(name: 'WorkPrice')
  double workPrice;

  /// 计件工资
  @JsonKey(name: 'PieceRateWage')
  double pieceRateWage;

  /// 其他奖惩金额
  @JsonKey(name: 'OIPAmount')
  double oIPAmount;

  /// 工艺内容
  @JsonKey(name: 'Content')
  String? content;

  /// 工艺要求
  @JsonKey(name: 'WorkRequirements')
  String? workRequirements;

  /// 是否开始
  @JsonKey(name: 'IsStarted')
  bool isStarted;

  /// 是否接收
  @JsonKey(name: 'ReceiveStatus')
  int receiveStatus; // Assuming you have a ProcessStatus enum defined

  /// 是否完工
  @JsonKey(name: 'CompleteStatus')
  int completeStatus; // Assuming you have a ProcessStatus enum defined

  /// 组装工序接收单id
  @JsonKey(name: 'AssemblyProcessReceiveDocumentid')
  int? assemblyProcessReceiveDocumentid;

  /// 组装工序完工单id
  @JsonKey(name: 'AssemblyProcessCompletionDocumentid')
  int? assemblyProcessCompletionDocumentid;

  /// 特殊单据id
  @JsonKey(name: 'StepDocumentid')
  int? stepDocumentid;

  /// 特殊单据表名
  @JsonKey(name: 'StepDocumentType')
  String? stepDocumentType;

  /// 可接收数
  @JsonKey(name: 'CanReceiveQty')
  double canReceiveQty;

  /// 已接收数
  @JsonKey(name: 'ReceivedQty')
  double receivedQty;

  /// 余下接收
  @JsonKey(name: 'WaitReceivedQty')
  double waitReceivedQty;

  /// 可完工数
  @JsonKey(name: 'CanCompleteQty')
  double canCompleteQty;

  /// 已完工数
  @JsonKey(name: 'CompleteQty')
  double completeQty;

  /// 余下完工
  @JsonKey(name: 'WaitCompleteQty')
  double waitCompleteQty;

  ProcessAssemblyFlowDetail({
    this.subPosition = 0,
    this.typeofWorkid = 0,
    this.vestInid = 0,
    this.bQty = 0,
    this.preCmpBQty = 0,
    this.badBQty = 0,
    this.cmpBQty = 0,
    this.workPrice = 0,
    this.pieceRateWage = 0,
    this.oIPAmount = 0,
    this.content,
    this.workRequirements,
    this.isStarted = false,
    this.assemblyProcessReceiveDocumentid,
    this.assemblyProcessCompletionDocumentid,
    this.stepDocumentid,
    this.stepDocumentType,
    this.canReceiveQty = 0,
    this.receivedQty = 0,
    this.waitReceivedQty = 0,
    this.canCompleteQty = 0,
    this.completeQty = 0,
    this.waitCompleteQty = 0,
  })  : receiveStatus = ProcessStatus.notStarted.value,
        completeStatus = ProcessStatus.notStarted.value;

  factory ProcessAssemblyFlowDetail.fromJson(Map<String, dynamic> json) =>
      _$ProcessAssemblyFlowDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessAssemblyFlowDetailToJson(this);
}

/// 流程状态枚举
enum ProcessStatus {
  /// 未开始
  notStarted(0),

  /// 进行中
  inProgress(1),

  /// 已完成
  completed(2),

  /// 禁用
  disabled(3);

  final int value;

  const ProcessStatus(this.value);
}
