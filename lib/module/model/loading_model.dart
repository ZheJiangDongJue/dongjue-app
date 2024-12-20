import 'package:flutter/material.dart';

class LoadingModel extends ChangeNotifier {
  /// 数据加载中
  bool _isDataLoading = false;
  bool get isDataLoading => _isDataLoading;

  set isDataLoading(bool value) {
    _isDataLoading = value;
    _loadingMessage = '';
    notifyListeners();
  }

  String _loadingMessage = '';
  String get loadingMessage => _loadingMessage;

  set loadingMessage(String value) {
    _loadingMessage = value;
    notifyListeners();
  }
}
