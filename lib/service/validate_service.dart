/// 正当なE-mail形式か判定
bool isValidEmai(String value) {
  return RegExp(r'.+@.+\..+').hasMatch(value);
}
