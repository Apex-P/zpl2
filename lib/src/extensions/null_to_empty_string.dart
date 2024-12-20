extension NullToEmptyString on Object? {
  /// Identical to [toString] unless this is null, in which case this returns
  /// the empty string.
  String nullToEmptyString() => this?.toString() ?? '';
}
