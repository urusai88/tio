List<String> _parts(String value) => value.split(RegExp('[-_]'));

String _caseFirst(
  String value, {
  required bool upper,
  required bool lower,
}) {
  assert((upper && !lower) || (!upper && lower));
  final parts = value.split('');
  if (parts.isEmpty) {
    return value;
  }
  return [
    if (upper) parts.first.toUpperCase() else parts.first.toLowerCase(),
    ...parts.skip(1),
  ].join();
}

class TioUtils {
  const TioUtils._();

  static String lowerCamel(String value) => _parts(value)
      .indexed
      .map((e) => e.$1 == 0 ? lowerCaseFirst(e.$2) : upperCaseFirst(e.$2))
      .join();

  static String upperCamel(String value) =>
      _parts(value).map(upperCaseFirst).join();

  static String lowerCaseFirst(String value) =>
      _caseFirst(value, upper: false, lower: true);

  static String upperCaseFirst(String value) =>
      _caseFirst(value, upper: true, lower: false);
}
