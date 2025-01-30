import 'package:dongjue_application/extensions/T.dart';

extension MapExtension on Map {
  T? getField<T>(String key) {
    // 没有属性的情况
    if (!containsKey(key)) {
      return null;
    }
    // 有属性但是没有值的情况
    if (this[key] == null) {
      return getDefaultValue<T>();
    }
    // 有属性有值的情况
    return this[key] as T;
  }
}