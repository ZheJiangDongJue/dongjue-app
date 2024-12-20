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
  int Static;
  int DetailCode;
  String? Message;
  String? Data;

  ApiMessagePack({
    this.Static = 0,
    this.DetailCode = 0,
    this.Message,
    this.Data,
  });
}