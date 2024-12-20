import 'package:intl/intl.dart';

extension StringFormatter on String {}

extension DoubleFormatter on double {
  static final Map<int, NumberFormat> _formatters = {};

  String format(int decimalPlaces) {
    if (!_formatters.containsKey(decimalPlaces)) {
      String pattern = '#.';
      for (int i = 0; i < decimalPlaces; i++) {
        pattern += '#';
      }
      _formatters[decimalPlaces] = NumberFormat(pattern);
    }
    return _formatters[decimalPlaces]!.format(this);
  }
}
