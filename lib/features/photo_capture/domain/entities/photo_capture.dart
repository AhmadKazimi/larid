class PhotoCapture {
  final String customerCode;
  final String? beforeImagePath;
  final String? afterImagePath;
  final int timestamp;

  PhotoCapture({
    required this.customerCode,
    this.beforeImagePath,
    this.afterImagePath,
    required this.timestamp,
  });

  bool get isComplete => beforeImagePath != null && afterImagePath != null;
}
