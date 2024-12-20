import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  //保留日期部分
  DateTime get dateOnly {
    return DateTime(year, month, day).toUtc();
  }

  String formatDate() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(this);
    return formatted;
  }
}
