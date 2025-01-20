class User {
  final int? id;
  final String name;
  final String email;
  final String? profileImage;
  final String createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'created_at': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profile_image'],
      createdAt: map['created_at'],
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImage,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 