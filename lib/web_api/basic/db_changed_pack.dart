class DbChangedPackResult {
  int id;
  int accountId;
  bool isSuccess;
  String? errorMessage;
  Map<String, dynamic>? objects;
  List<dynamic>? addItems;
  List<dynamic>? updateItems;
  List<dynamic>? deleteItems;

  static final List<dynamic> _nullArray = [];

  DbChangedPackResult({
    this.id = 0,
    this.accountId = 0,
    this.isSuccess = false,
    this.errorMessage,
    this.objects,
    this.addItems,
    this.updateItems,
    this.deleteItems,
  });
}

class ApiMessagePack{
  int status;
  int detailCode;
  String? message;
  String? data;

  ApiMessagePack({
    this.status = 0,
    this.detailCode = 0,
    this.message,
    this.data,
  });
}