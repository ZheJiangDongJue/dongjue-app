import 'package:dongjue_application/orm/interfaces/interfaces.dart';
import 'package:json_annotation/json_annotation.dart';

import 'entity_base.dart';

@JsonSerializable()
abstract class GeneralEntityBase extends EntityBase implements INode {
  /// 二级明细,物料清单用到
  @JsonKey(name: 'Parentid') // Adjust name if necessary based on your backend
  int? parentId;

  ///  This property will not be serialized/deserialized since it's not mapped and ignored.
  @JsonKey(ignore: true) // Ensure it's ignored for JSON serialization
  String?
      tempParentId; // Using String since Guid in C# can be represented as string in Dart

  GeneralEntityBase(
      {this.parentId,
      this.tempParentId,
      super.createByUserid,
      super.deletedTag});
}
