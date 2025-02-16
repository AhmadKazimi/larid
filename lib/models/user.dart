class User {
  final int? id;
  final String workspace;
  final String password;
  final String baseUrl;
  final DateTime? createdAt;

  User({
    this.id,
    required this.workspace,
    required this.password,
    required this.baseUrl,
    this.createdAt,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workspace': workspace,
      'password': password,
      'baseUrl': baseUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      workspace: map['workspace'],
      password: map['password'],
      baseUrl: map['baseUrl'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
    );
  }
}
