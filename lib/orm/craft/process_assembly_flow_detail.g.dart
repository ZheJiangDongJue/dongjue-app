// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_assembly_flow_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessAssemblyFlowDetail _$ProcessAssemblyFlowDetailFromJson(
        Map<String, dynamic> json) =>
    ProcessAssemblyFlowDetail(
      subPosition: (json['SubPosition'] as num?)?.toInt() ?? 0,
      typeofWorkid: (json['TypeofWorkid'] as num?)?.toInt() ?? 0,
      vestInid: (json['VestInid'] as num?)?.toInt() ?? 0,
      bQty: (json['BQty'] as num?)?.toDouble() ?? 0,
      preCmpBQty: (json['PreCmpBQty'] as num?)?.toDouble() ?? 0,
      badBQty: (json['BadBQty'] as num?)?.toDouble() ?? 0,
      cmpBQty: (json['CmpBQty'] as num?)?.toDouble() ?? 0,
      workPrice: (json['WorkPrice'] as num?)?.toDouble() ?? 0,
      pieceRateWage: (json['PieceRateWage'] as num?)?.toDouble() ?? 0,
      oIPAmount: (json['OIPAmount'] as num?)?.toDouble() ?? 0,
      content: json['Content'] as String?,
      workRequirements: json['WorkRequirements'] as String?,
      isStarted: json['IsStarted'] as bool? ?? false,
      assemblyProcessReceiveDocumentid:
          (json['AssemblyProcessReceiveDocumentid'] as num?)?.toInt(),
      assemblyProcessCompletionDocumentid:
          (json['AssemblyProcessCompletionDocumentid'] as num?)?.toInt(),
      stepDocumentid: (json['StepDocumentid'] as num?)?.toInt(),
      stepDocumentType: json['StepDocumentType'] as String?,
      canReceiveQty: (json['CanReceiveQty'] as num?)?.toDouble() ?? 0,
      receivedQty: (json['ReceivedQty'] as num?)?.toDouble() ?? 0,
      waitReceivedQty: (json['WaitReceivedQty'] as num?)?.toDouble() ?? 0,
      canCompleteQty: (json['CanCompleteQty'] as num?)?.toDouble() ?? 0,
      completeQty: (json['CompleteQty'] as num?)?.toDouble() ?? 0,
      waitCompleteQty: (json['WaitCompleteQty'] as num?)?.toDouble() ?? 0,
    )
      ..id = (json['id'] as num).toInt()
      ..locationIndex = (json['LocationIndex'] as num).toDouble()
      ..uid = (json['Uid'] as num).toInt()
      ..createTime = json['CreateTime'] == null
          ? null
          : DateTime.parse(json['CreateTime'] as String)
      ..updateTime = json['UpdateTime'] == null
          ? null
          : DateTime.parse(json['UpdateTime'] as String)
      ..createByUserid = (json['CreateByUserid'] as num).toInt()
      ..updateByUserid = (json['UpdateByUserid'] as num?)?.toInt()
      ..deletedTag = json['DeletedTag'] as bool
      ..deleteTime = json['DeleteTime'] == null
          ? null
          : DateTime.parse(json['DeleteTime'] as String)
      ..deleteByUserid = (json['DeleteByUserid'] as num?)?.toInt()
      ..parentId = (json['Parentid'] as num?)?.toInt()
      ..ParentTypeid = (json['ParentTypeid'] as num).toInt()
      ..flowUid = (json['FlowUid'] as num).toInt()
      ..flowLayer = (json['FlowLayer'] as num).toInt()
      ..createByDocumentId = (json['CreateByDocumentid'] as num?)?.toInt()
      ..createByDocumentType = json['CreateByDocumentType'] as String?
      ..createByDetailId = (json['CreateByDetailid'] as num?)?.toInt()
      ..createByDetailType = json['CreateByDetailType'] as String?
      ..status = (json['Status'] as num).toInt()
      ..finishTime = json['FinishTime'] == null
          ? null
          : DateTime.parse(json['FinishTime'] as String)
      ..finishByUserId = (json['FinishByUserid'] as num?)?.toInt()
      ..note = json['Note'] as String?
      ..codeForScan = json['CodeForScan'] as String?
      ..lastPrintUserId = (json['LastPrintUserid'] as num?)?.toInt()
      ..lastPrintUserUid = (json['LastPrintUserUid'] as num?)?.toInt()
      ..lastPrintTime = json['LastPrintTime'] == null
          ? null
          : DateTime.parse(json['LastPrintTime'] as String)
      ..printCount = (json['PrintCount'] as num).toInt()
      ..receiveStatus = (json['ReceiveStatus'] as num).toInt()
      ..completeStatus = (json['CompleteStatus'] as num).toInt();

Map<String, dynamic> _$ProcessAssemblyFlowDetailToJson(
        ProcessAssemblyFlowDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'LocationIndex': instance.locationIndex,
      'Uid': instance.uid,
      'CreateTime': instance.createTime?.toIso8601String(),
      'UpdateTime': instance.updateTime?.toIso8601String(),
      'CreateByUserid': instance.createByUserid,
      'UpdateByUserid': instance.updateByUserid,
      'DeletedTag': instance.deletedTag,
      'DeleteTime': instance.deleteTime?.toIso8601String(),
      'DeleteByUserid': instance.deleteByUserid,
      'Parentid': instance.parentId,
      'ParentTypeid': instance.ParentTypeid,
      'FlowUid': instance.flowUid,
      'FlowLayer': instance.flowLayer,
      'CreateByDocumentid': instance.createByDocumentId,
      'CreateByDocumentType': instance.createByDocumentType,
      'CreateByDetailid': instance.createByDetailId,
      'CreateByDetailType': instance.createByDetailType,
      'Status': instance.status,
      'FinishTime': instance.finishTime?.toIso8601String(),
      'FinishByUserid': instance.finishByUserId,
      'Note': instance.note,
      'CodeForScan': instance.codeForScan,
      'LastPrintUserid': instance.lastPrintUserId,
      'LastPrintUserUid': instance.lastPrintUserUid,
      'LastPrintTime': instance.lastPrintTime?.toIso8601String(),
      'PrintCount': instance.printCount,
      'SubPosition': instance.subPosition,
      'TypeofWorkid': instance.typeofWorkid,
      'VestInid': instance.vestInid,
      'BQty': instance.bQty,
      'PreCmpBQty': instance.preCmpBQty,
      'BadBQty': instance.badBQty,
      'CmpBQty': instance.cmpBQty,
      'WorkPrice': instance.workPrice,
      'PieceRateWage': instance.pieceRateWage,
      'OIPAmount': instance.oIPAmount,
      'Content': instance.content,
      'WorkRequirements': instance.workRequirements,
      'IsStarted': instance.isStarted,
      'ReceiveStatus': instance.receiveStatus,
      'CompleteStatus': instance.completeStatus,
      'AssemblyProcessReceiveDocumentid':
          instance.assemblyProcessReceiveDocumentid,
      'AssemblyProcessCompletionDocumentid':
          instance.assemblyProcessCompletionDocumentid,
      'StepDocumentid': instance.stepDocumentid,
      'StepDocumentType': instance.stepDocumentType,
      'CanReceiveQty': instance.canReceiveQty,
      'ReceivedQty': instance.receivedQty,
      'WaitReceivedQty': instance.waitReceivedQty,
      'CanCompleteQty': instance.canCompleteQty,
      'CompleteQty': instance.completeQty,
      'WaitCompleteQty': instance.waitCompleteQty,
    };
