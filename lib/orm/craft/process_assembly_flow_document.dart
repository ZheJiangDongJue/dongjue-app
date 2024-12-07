import 'package:dongjue_application/orm/basic/bill_base.dart';
import 'package:dongjue_application/orm/interfaces/interfaces.dart';
import 'package:json_annotation/json_annotation.dart';

part 'process_assembly_flow_document.g.dart';

@JsonSerializable()
class ProcessAssemblyFlowDocument extends BillBase
    implements IDelivery, IHasClient, IOnlyHasMaterial, IInnerKey, IQty {
  @JsonKey(name: 'InnerKey')
  String? innerKey;

  @JsonKey(name: 'Materialid')
  int materialId;

  @JsonKey(name: 'Departmentid')
  int departmentId;

  @JsonKey(name: 'Clientid')
  int clientId;

  @JsonKey(name: 'DeliveryTime')
  DateTime? deliveryTime;

  @JsonKey(name: 'PreCmpBQty')
  double preCmpBQty;

  @JsonKey(name: 'CmpBQty')
  double cmpBQty;

  @JsonKey(name: 'BQty')
  double bQty;

  @JsonKey(name: 'RoutingDocumentid')
  int routingDocumentId;

  @JsonKey(name: 'IsCompleted')
  bool isCompleted;

  double get qty => preCmpBQty;
  set qty(double value) => preCmpBQty = value;

  ProcessAssemblyFlowDocument({
    this.innerKey,
    this.materialId = 0,
    this.departmentId = 0,
    this.clientId = 0,
    this.deliveryTime,
    this.preCmpBQty = 0,
    this.cmpBQty = 0,
    this.bQty = 0,
    this.routingDocumentId = 0,
    this.isCompleted = false,
    super.flowUid = 0,
    super.flowLayer = 0,
    super.code,
    super.isApproval,
    super.printCount,
    super.createByUserid,
    super.deletedTag,
  });

  factory ProcessAssemblyFlowDocument.fromJson(Map<String, dynamic> json) =>
      _$ProcessAssemblyFlowDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessAssemblyFlowDocumentToJson(this);
}
