class Validators {
  static bool isEmail(String value) => value.contains('@');
  static bool isNotEmpty(String? v) => v != null && v.trim().isNotEmpty;
}
