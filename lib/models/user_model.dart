class User {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
      'profileImageUrl': profileImageUrl,
    };
  }
}
