class PendingUpload {
  final String imagePath;
  final String customerCode;
  final bool isBefore;
  final int timestamp;

  PendingUpload({
    required this.imagePath,
    required this.customerCode,
    required this.isBefore,
    required this.timestamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'customerCode': customerCode,
      'isBefore': isBefore,
      'timestamp': timestamp,
    };
  }

  // Create from JSON
  factory PendingUpload.fromJson(Map<String, dynamic> json) {
    return PendingUpload(
      imagePath: json['imagePath'] as String,
      customerCode: json['customerCode'] as String,
      isBefore: json['isBefore'] as bool,
      timestamp: json['timestamp'] as int,
    );
  }
}
