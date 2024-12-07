import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class UniqueEntity {
  @JsonKey(name: "id")
  int id = 0;

  @JsonKey(name: "LocationIndex")
  double locationIndex = 0.0;

  @JsonKey(name: "Uid")
  int uid = 0;
}
