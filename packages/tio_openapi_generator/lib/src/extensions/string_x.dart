extension StringX on String {
  String get camel {
    final parts = split(RegExp('[-_]'));
    if (parts.isEmpty) {
      return this;
    }
    return [
      parts.first.toLowerCase(),
      ...parts.skip(1).map((e) => e.upperFirst),
    ].join();
  }

  String get lowerFirst => _caseFirst(upper: false, lower: true);

  String get upperFirst => _caseFirst(upper: true, lower: false);

  String _caseFirst({required bool upper, required bool lower}) {
    assert((upper && !lower) || (!upper && lower));
    final parts = split('');
    if (parts.isEmpty) {
      return this;
    }
    return [
      if (upper) parts.first.toUpperCase() else parts.first.toLowerCase(),
      ...parts.skip(1),
    ].join();
  }
}
