class User {
  final int? id;
  final String workspaceId;
  final String password;
  final String baseUrl;
  final DateTime? createdAt;

  User({
    this.id,
    required this.workspaceId,
    required this.password,
    required this.baseUrl,
    this.createdAt,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workspaceId': workspaceId,
      'password': password,
      'baseUrl': baseUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      workspaceId: map['workspaceId'],
      password: map['password'],
      baseUrl: map['baseUrl'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
    );
  }
}
