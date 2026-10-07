class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? profileImage;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.role,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] ?? 'CLIENT',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
