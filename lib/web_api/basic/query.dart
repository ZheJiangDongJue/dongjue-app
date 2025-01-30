import 'dart:convert';

enum JoinType { inner, left, right, full }

class Query {
  String? tableName;
  String? shortName;
  List<String>? where;
  String? order;
  List<JoinInfo>? joinInfos;
  String? groupBy;
  String? having;
  String? select;
  int? pageNumber;
  int? pageSize;
  String? selectMode;

  Query({
    this.tableName,
    this.shortName,
    this.where,
    this.order,
    this.joinInfos,
    this.groupBy,
    this.having,
    this.select,
    this.pageNumber,
    this.pageSize,
    this.selectMode,
  });

  Query addWhere(String whereClause) {
    where ??= <String>[];
    where!.add(whereClause);
    return this;
  }

  Query addJoin(JoinType joinType, String tableName, String shortName, String on) {
    joinInfos ??= <JoinInfo>[];
    joinInfos!.add(JoinInfo(
      joinType: joinType,
      tableName: tableName,
      shortName: shortName,
      on: on,
    ));
    return this;
  }

  Map<String, dynamic> toJson() => {
        'TableName': tableName,
        'ShortName': shortName,
        'Where': where,
        'Order': order,
        'JoinInfos': joinInfos?.map((e) => e.toJson()).toList(),
        'GroupBy': groupBy,
        'Having': having,
        'Select': select,
        'PageNumber': pageNumber,
        'PageSize': pageSize,
        'SelectMode': selectMode,
      };

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        tableName: json['TableName'] as String?,
        shortName: json['ShortName'] as String?,
        where: (json['Where'] as List?)?.map((e) => e as String).toList(),
        order: json['Order'] as String?,
        joinInfos: (json['JoinInfos'] as List?)?.map((e) => JoinInfo.fromJson(e as Map<String, dynamic>)).toList(),
        groupBy: json['GroupBy'] as String?,
        having: json['Having'] as String?,
        select: json['Select'] as String?,
        pageNumber: json['PageNumber'] as int?,
        pageSize: json['PageSize'] as int?,
        selectMode: json['SelectMode'] as String?,
      );

  @override
  String toString() => jsonEncode(toJson());
}

class JoinInfo {
  JoinType joinType;
  String tableName;
  String shortName;
  String on;

  JoinInfo({
    required this.joinType,
    required this.tableName,
    required this.shortName,
    required this.on,
  });

  Map<String, dynamic> toJson() => {
        'JoinType': joinType.toString().split('.').last, // Convert enum to string
        'TableName': tableName,
        'ShortName': shortName,
        'On': on,
      };

  factory JoinInfo.fromJson(Map<String, dynamic> json) => JoinInfo(
        joinType: _getJoinTypeFromString(json['JoinType'] as String),
        tableName: json['TableName'] as String,
        shortName: json['ShortName'] as String,
        on: json['On'] as String,
      );
}

JoinType _getJoinTypeFromString(String joinTypeString) {
  switch (joinTypeString.toLowerCase()) {
    case 'inner':
      return JoinType.inner;
    case 'left':
      return JoinType.left;
    case 'right':
      return JoinType.right;
    case 'full':
      return JoinType.full;
    default:
      throw ArgumentError('Invalid join type string: $joinTypeString');
  }
}
