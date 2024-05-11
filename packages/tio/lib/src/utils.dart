class TioUtils {
  const TioUtils._();

  static List<String> parts(String value) => value.split(RegExp('[-_]'));

  static String lowerCamel(String value) {
    final parts = TioUtils.parts(value);
    return [
      if (parts.isNotEmpty) lowerCaseFirst(value),
      ...parts.skip(1).map((e) => upperCaseFirst(value)),
    ].join();
  }

  static String upperCamel(String value) {
    final parts = TioUtils.parts(value);
    return [
      if (parts.isNotEmpty) upperCaseFirst(value),
      ...parts.skip(1).map((e) => upperCaseFirst(value)),
    ].join();
  }

  static String lowerCaseFirst(String value) =>
      _caseFirst(value, upper: false, lower: true);

  static String upperCaseFirst(String value) =>
      _caseFirst(value, upper: true, lower: false);

  static String _caseFirst(
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
}
