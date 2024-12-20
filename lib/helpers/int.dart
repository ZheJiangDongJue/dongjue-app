extension IntExtension on int {
  bool HasFlag(int flag) {
    if (this & flag != 0) {
      return true;
    }
    return false;
  }
}