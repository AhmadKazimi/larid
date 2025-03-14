class PhotoCapture {
  final String customerCode;
  final String? beforeImagePath;
  final String? afterImagePath;

  PhotoCapture({
    required this.customerCode,
    this.beforeImagePath,
    this.afterImagePath,
  });

  bool get isComplete => beforeImagePath != null && afterImagePath != null;
}
