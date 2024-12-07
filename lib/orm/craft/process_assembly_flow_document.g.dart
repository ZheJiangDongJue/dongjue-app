// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_assembly_flow_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessAssemblyFlowDocument _$ProcessAssemblyFlowDocumentFromJson(
        Map<String, dynamic> json) =>
    ProcessAssemblyFlowDocument(
      innerKey: json['InnerKey'] as String?,
      materialId: (json['Materialid'] as num?)?.toInt() ?? 0,
      departmentId: (json['Departmentid'] as num?)?.toInt() ?? 0,
      clientId: (json['Clientid'] as num?)?.toInt() ?? 0,
      deliveryTime: json['DeliveryTime'] == null
          ? null
          : DateTime.parse(json['DeliveryTime'] as String),
      preCmpBQty: (json['PreCmpBQty'] as num?)?.toDouble() ?? 0,
      cmpBQty: (json['CmpBQty'] as num?)?.toDouble() ?? 0,
      bQty: (json['BQty'] as num?)?.toDouble() ?? 0,
      routingDocumentId: (json['RoutingDocumentid'] as num?)?.toInt() ?? 0,
      isCompleted: json['IsCompleted'] as bool? ?? false,
      flowUid: (json['FlowUid'] as num?)?.toInt() ?? 0,
      flowLayer: (json['FlowLayer'] as num?)?.toInt() ?? 0,
      code: json['Code'] as String? ?? '',
      isApproval: json['IsApproval'] as bool? ?? false,
      printCount: (json['PrintCount'] as num?)?.toInt() ?? 0,
      createByUserid: (json['CreateByUserid'] as num?)?.toInt() ?? 0,
      deletedTag: json['DeletedTag'] as bool? ?? false,
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
      ..updateByUserid = (json['UpdateByUserid'] as num?)?.toInt()
      ..deleteTime = json['DeleteTime'] == null
          ? null
          : DateTime.parse(json['DeleteTime'] as String)
      ..deleteByUserid = (json['DeleteByUserid'] as num?)?.toInt()
      ..parentId = (json['Parentid'] as num?)?.toInt()
      ..documentTime = DateTime.parse(json['DocumentTime'] as String)
      ..createByDocumentId = (json['CreateByDocumentid'] as num?)?.toInt()
      ..createByDocumentType = json['CreateByDocumentType'] as String?
      ..createByDetailId = (json['CreateByDetailid'] as num?)?.toInt()
      ..createByDetailType = json['CreateByDetailType'] as String?
      ..approvalTime = json['ApprovalTime'] == null
          ? null
          : DateTime.parse(json['ApprovalTime'] as String)
      ..approvalByUserId = (json['ApprovalByUserid'] as num?)?.toInt()
      ..status = (json['Status'] as num).toInt()
      ..finishTime = json['FinishTime'] == null
          ? null
          : DateTime.parse(json['FinishTime'] as String)
      ..finishByUserId = (json['FinishByUserid'] as num?)?.toInt()
      ..note = json['Note'] as String?
      ..lastPrintUserId = (json['LastPrintUserid'] as num?)?.toInt()
      ..lastPrintUserUid = (json['LastPrintUserUid'] as num?)?.toInt()
      ..lastPrintTime = json['LastPrintTime'] == null
          ? null
          : DateTime.parse(json['LastPrintTime'] as String)
      ..qty = (json['qty'] as num).toDouble();

Map<String, dynamic> _$ProcessAssemblyFlowDocumentToJson(
        ProcessAssemblyFlowDocument instance) =>
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
      'FlowUid': instance.flowUid,
      'FlowLayer': instance.flowLayer,
      'DocumentTime': instance.documentTime.toIso8601String(),
      'Code': instance.code,
      'CreateByDocumentid': instance.createByDocumentId,
      'CreateByDocumentType': instance.createByDocumentType,
      'CreateByDetailid': instance.createByDetailId,
      'CreateByDetailType': instance.createByDetailType,
      'ApprovalTime': instance.approvalTime?.toIso8601String(),
      'ApprovalByUserid': instance.approvalByUserId,
      'IsApproval': instance.isApproval,
      'Status': instance.status,
      'FinishTime': instance.finishTime?.toIso8601String(),
      'FinishByUserid': instance.finishByUserId,
      'Note': instance.note,
      'LastPrintUserid': instance.lastPrintUserId,
      'LastPrintUserUid': instance.lastPrintUserUid,
      'LastPrintTime': instance.lastPrintTime?.toIso8601String(),
      'PrintCount': instance.printCount,
      'InnerKey': instance.innerKey,
      'Materialid': instance.materialId,
      'Departmentid': instance.departmentId,
      'Clientid': instance.clientId,
      'DeliveryTime': instance.deliveryTime?.toIso8601String(),
      'PreCmpBQty': instance.preCmpBQty,
      'CmpBQty': instance.cmpBQty,
      'BQty': instance.bQty,
      'RoutingDocumentid': instance.routingDocumentId,
      'IsCompleted': instance.isCompleted,
      'qty': instance.qty,
    };
