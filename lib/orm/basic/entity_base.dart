import 'package:dongjue_application/orm/basic/unique_entity.dart';
import 'package:dongjue_application/orm/interfaces/interfaces.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class EntityBase extends UniqueEntity
    implements IChangedInfo, IDeleteTag {
  @JsonKey(name: 'CreateTime')
  DateTime? createTime;

  @JsonKey(name: 'UpdateTime')
  DateTime? updateTime;

  @JsonKey(name: 'CreateByUserid')
  int createByUserid;

  @JsonKey(name: 'UpdateByUserid')
  int? updateByUserid;

  @JsonKey(ignore: true)
  DateTime get lastChangeTime {
    final created = createTime ?? DateTime.fromMicrosecondsSinceEpoch(0);
    final updated = updateTime ?? created;
    return created.isAfter(updated) ? created : updated;
  }

  @JsonKey(name: 'DeletedTag')
  bool deletedTag;

  @JsonKey(name: 'DeleteTime')
  DateTime? deleteTime;

  @JsonKey(name: 'DeleteByUserid')
  int? deleteByUserid;

  EntityBase({
    this.createByUserid = 0,
    this.createTime,
    this.updateTime,
    this.updateByUserid,
    this.deletedTag = false,
    this.deleteTime,
    this.deleteByUserid,
  });
}
