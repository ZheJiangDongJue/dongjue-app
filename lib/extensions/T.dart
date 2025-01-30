extension TExtension on Object {
  T getDefaultValue<T>() {
    final defaultValues = <Type, Object>{
      int: 0,
      double: 0.0,
      String: '',
      bool: false,
    };
    return defaultValues[T] as T; // 注意类型转换
  }
}
