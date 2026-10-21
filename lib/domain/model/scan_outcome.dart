/// Result of processing this QR, independent of previously saved marks.
enum ScanOutcome {
  recorded,
  repeated,
  invalid,
  failed;

  bool get confirmed => this == recorded || this == repeated;
}
