class User {
  final int? id;
  final String name;
  final String email;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
    );
  }
}
